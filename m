Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99C03E16A9;
	Tue, 22 Sep 2026 03:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790048800; cv=none; b=bGfxWqLmqwRrN8E++ElQ6nQCloYXmubCrpVepzGWuYLUE0DavWCN7lWqMiPKh58qAKiqNMIPp/zZWiqnCUoPExWta460nZP+SwquWKCtOLEcq7kVW2mufJPfPoUhbhLvJkUxbrF3bKaqHaqHAqEKH0XHmvdJcNX2rXp1A1L1oj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790048800; c=relaxed/simple;
	bh=BKN1Aem1fyBH8DcFCg0ctBZjBfVUEYBZZuv4CVO1Zp0=;
	h=Date:To:From:Subject:Message-Id; b=XAZoyQlOztMxIJL5DHl5jVdXnzmdFPnol0CZ2lUd5JMr9Gvg5fxe2z0PiQib011hzOpJw7GFgrFD1IYIRrenyBmQt5w+f58pIdsoW+6oz98kRc2RuBx5RodWYRA+ZnzNvsdw92336M3bDX+jnFJ/89/cOA8bWouOCM1v/km7at4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UsU3dorh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UsU3dorh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4321F00893;
	Tue, 22 Sep 2026 03:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790048798;
	bh=92nu685JQJb1nqLJWOzKyrPk5QVyy+X7GxH3tkQfg3A=;
	h=Date:To:From:Subject;
	b=UsU3dorhVn+vxGEAGXtFdoIg9vcXdyMdUClr0SUiB5TcUh9emF8iMGZyZ9doqtafc
	 SnYRDJZmxQXmnOZ2WtU4DNFnd6ASl7JQosEVD1ZOCjsJke5XM/lhviwTwGBwO+h+/J
	 7NGcdL5R0AU5HZjfceDeI2er4rEt3Sj64+qgr9XA=
Date: Mon, 21 Sep 2026 20:46:37 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch removed from -mm tree
Message-Id: <20260922034638.1C4321F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: remove /proc/allocinfo outside of mod_lock
has been removed from the -mm tree.  Its filename was
     alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: alloc_tag: remove /proc/allocinfo outside of mod_lock
Date: Mon, 17 Aug 2026 14:27:26 +0800

shutdown_mem_profiling() calls remove_proc_entry() from
reserve_module_tags(), which runs under mod_lock held for write. 
remove_proc_entry() waits for readers, and a reader takes mod_lock for
read in allocinfo_start():

  CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
  ----------------                   ----------------------------
  reserve_module_tags()
    down_write(&mod_lock)  [held]
                                     use_pde()            [in_use++]
                                     allocinfo_start()
                                       down_read(&mod_lock)  <- blocks
    shutdown_mem_profiling()
      remove_proc_entry()
        wait for in_use == 0         <- blocks

Move remove_proc_entry() to a workqueue.

Link: https://lore.kernel.org/20260817062726.106511-3-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/alloc_tag.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/alloc_tag.c~alloc_tag-remove-proc-allocinfo-outside-of-mod_lock
+++ a/mm/alloc_tag.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/string_choices.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <linux/kmemleak.h>
 #include <uapi/linux/alloc_tag.h>
 
@@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new,
 	put_page_tag_ref(handle_new);
 }
 
+static void remove_allocinfo_file(struct work_struct *work)
+{
+	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+}
+
+static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
+
 static void shutdown_mem_profiling(bool remove_file)
 {
 	if (mem_alloc_profiling_enabled())
@@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool
 		return;
 
 	if (remove_file)
-		remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+		schedule_work(&remove_allocinfo_work);
 	mem_profiling_support = false;
 }
 
_

Patches currently in -mm which might be from hao.ge@linux.dev are

module-fix-lost-error-code-from-codetag_load_module.patch
mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch

