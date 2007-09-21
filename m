From: akpm@linux-foundation.org
Subject: + git-nfs-vs-nfs-convert-to-new-aops-fix.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:36:26 -0700
Message-ID: <200709210636.l8L6aQIN022786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbXIUGhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, nickpiggin@yahoo.com.au, trond.myklebust@fys.uio.no


The patch titled
     git-nfs-vs-nfs-convert-to-new-aops fix
has been added to the -mm tree.  Its filename is
     git-nfs-vs-nfs-convert-to-new-aops-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-nfs-vs-nfs-convert-to-new-aops fix
From: Peter Zijlstra <peterz@infradead.org>

On Mon, 20 Aug 2007 15:56:10 -0700 akpm@linux-foundation.org wrote:

> ------------------------------------------------------
> Subject: git-nfs vs nfs-convert-to-new-aops
> From: Andrew Morton <akpm@linux-foundation.org>
>
> nfi if this is correct.  How am I supposed to know how to work out what to put
> in `copied' in write_end?

I can has broken NFS :-)

nfs_write_begin wants to lock the page itself, but we pass it a locked
page.

> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/nfs/file.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff -puN fs/nfs/file.c~git-nfs-vs-nfs-convert-to-new-aops fs/nfs/file.c
> --- a/fs/nfs/file.c~git-nfs-vs-nfs-convert-to-new-aops
> +++ a/fs/nfs/file.c
> @@ -392,6 +392,7 @@ static int nfs_vm_page_mkwrite(struct vm
>  	struct file *filp = vma->vm_file;
>  	unsigned pagelen;
>  	int ret = -EINVAL;
> +	void *fsdata;
>
>  	lock_page(page);
>  	if (page->mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping)
> @@ -399,9 +400,13 @@ static int nfs_vm_page_mkwrite(struct vm
>  	pagelen = nfs_page_length(page);
>  	if (pagelen == 0)
>  		goto out_unlock;
> -	ret = nfs_prepare_write(filp, page, 0, pagelen);
> +	ret = nfs_write_begin(filp, page->mapping,
> +				(loff_t)page->index << PAGE_CACHE_SHIFT,
> +				pagelen, 0, &page, &fsdata);
>  	if (!ret)
> -		ret = nfs_commit_write(filp, page, 0, pagelen);
> +		ret = nfs_write_end(filp, page->mapping,
> +				(loff_t)page->index << PAGE_CACHE_SHIFT,
> +				pagelen, pagelen, page, fsdata);
>  out_unlock:
>  	unlock_page(page);
>  	return ret;
> _

But even with this patch I deadlock on page lock, just not here
anymore :-/

/me continues the mmap write on nfs adventure...

Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/file.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff -puN fs/nfs/file.c~git-nfs-vs-nfs-convert-to-new-aops-fix fs/nfs/file.c
--- a/fs/nfs/file.c~git-nfs-vs-nfs-convert-to-new-aops-fix
+++ a/fs/nfs/file.c
@@ -393,22 +393,34 @@ static int nfs_vm_page_mkwrite(struct vm
 	unsigned pagelen;
 	int ret = -EINVAL;
 	void *fsdata;
+	struct address_space *mapping;
+	loff_t offset;
 
 	lock_page(page);
-	if (page->mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping)
-		goto out_unlock;
+	mapping = page->mapping;
+	if (mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping) {
+		unlock_page(page);
+		return -EINVAL;
+	}
 	pagelen = nfs_page_length(page);
-	if (pagelen == 0)
-		goto out_unlock;
-	ret = nfs_write_begin(filp, page->mapping,
-				(loff_t)page->index << PAGE_CACHE_SHIFT,
-				pagelen, 0, &page, &fsdata);
-	if (!ret)
-		ret = nfs_write_end(filp, page->mapping,
-				(loff_t)page->index << PAGE_CACHE_SHIFT,
-				pagelen, pagelen, page, fsdata);
-out_unlock:
+	offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	unlock_page(page);
+
+	/*
+	 * we can use mapping after releasing the page lock, because:
+	 * we hold mmap_sem on the fault path, which should pin the vma
+	 * which should pin the file, which pins the dentry which should
+	 * hold a reference on inode.
+	 */
+
+	if (pagelen) {
+		struct page *page2 = NULL;
+		ret = nfs_write_begin(filp, mapping, offset, pagelen,
+			       	0, &page2, &fsdata);
+		if (!ret)
+			ret = nfs_write_end(filp, mapping, offset, pagelen,
+				       	pagelen, page2, fsdata);
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from peterz@infradead.org are

readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
