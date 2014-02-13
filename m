From: akpm@linux-foundation.org
Subject: + jffs2-fix-unbalanced-locking-v2.patch added to -mm tree
Date: Thu, 13 Feb 2014 13:08:39 -0800
Message-ID: <52fd3457.ZpbpDq27rzClcETN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBMVIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 16:08:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dwmw2@infradead.org, computersforpeace@gmail.com, artem.bityutskiy@linux.intel.com, lizefan@huawei.com

Subject: + jffs2-fix-unbalanced-locking-v2.patch added to -mm tree
To: lizefan@huawei.com,artem.bityutskiy@linux.intel.com,computersforpeace@gmail.com,dwmw2@infradead.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 13:08:39 -0800


The patch titled
     Subject: jffs2: fix unbalanced locking
has been added to the -mm tree.  Its filename is
     jffs2-fix-unbalanced-locking-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jffs2-fix-unbalanced-locking-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jffs2-fix-unbalanced-locking-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: jffs2: fix unbalanced locking

On runtime our internal debugging feature warned f->sem isn't unlocked
when returning to userspace.  It's because f->sem isn't unlocked in
jffs2_do_crccheck_inode() on error, but this bug won't lead to deadlock,
as the structure that this lock is embedded in is freed immediately.

After looking into the code, I found in jffs2_do_read_inode_internal()
some error paths release f->sem but some won't, so this may lead to
double-unlock:

  jffs2_iget()
  |_ mutex_lock(&f->sem)
  |_ jffs2_do_read_inode()
  |  |_ jffs2_do_read_inode_internal()
  |     |_ mutex_unlock(&f->sem)
  |     |_ jffs2_do_clear_inode(c, f)
  |     |_ return ret
  |_ mutex_unlock(&f->sem)

This patch makes sure jffs2_do_read_inode_internal() never returns with
f->sem unlocked, so locking and unlocking are in the same level.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/readinode.c |   53 ++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff -puN fs/jffs2/readinode.c~jffs2-fix-unbalanced-locking-v2 fs/jffs2/readinode.c
--- a/fs/jffs2/readinode.c~jffs2-fix-unbalanced-locking-v2
+++ a/fs/jffs2/readinode.c
@@ -1203,18 +1203,16 @@ static int jffs2_do_read_inode_internal(
 		JFFS2_ERROR("failed to read from flash: error %d, %zd of %zd bytes read\n",
 			ret, retlen, sizeof(*latest_node));
 		/* FIXME: If this fails, there seems to be a memory leak. Find it. */
-		mutex_unlock(&f->sem);
-		jffs2_do_clear_inode(c, f);
-		return ret?ret:-EIO;
+		ret = ret ? ret : -EIO;
+		goto out;
 	}
 
 	crc = crc32(0, latest_node, sizeof(*latest_node)-8);
 	if (crc != je32_to_cpu(latest_node->node_crc)) {
 		JFFS2_ERROR("CRC failed for read_inode of inode %u at physical location 0x%x\n",
 			f->inocache->ino, ref_offset(rii.latest_ref));
-		mutex_unlock(&f->sem);
-		jffs2_do_clear_inode(c, f);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	switch(jemode_to_cpu(latest_node->mode) & S_IFMT) {
@@ -1251,16 +1249,14 @@ static int jffs2_do_read_inode_internal(
 			 * operation. */
 			uint32_t csize = je32_to_cpu(latest_node->csize);
 			if (csize > JFFS2_MAX_NAME_LEN) {
-				mutex_unlock(&f->sem);
-				jffs2_do_clear_inode(c, f);
-				return -ENAMETOOLONG;
+				ret = -ENAMETOOLONG;
+				goto out;
 			}
 			f->target = kmalloc(csize + 1, GFP_KERNEL);
 			if (!f->target) {
 				JFFS2_ERROR("can't allocate %u bytes of memory for the symlink target path cache\n", csize);
-				mutex_unlock(&f->sem);
-				jffs2_do_clear_inode(c, f);
-				return -ENOMEM;
+				ret = -ENOMEM;
+				goto out;
 			}
 
 			ret = jffs2_flash_read(c, ref_offset(rii.latest_ref) + sizeof(*latest_node),
@@ -1271,9 +1267,7 @@ static int jffs2_do_read_inode_internal(
 					ret = -EIO;
 				kfree(f->target);
 				f->target = NULL;
-				mutex_unlock(&f->sem);
-				jffs2_do_clear_inode(c, f);
-				return ret;
+				goto out;
 			}
 
 			f->target[csize] = '\0';
@@ -1289,25 +1283,22 @@ static int jffs2_do_read_inode_internal(
 		if (f->metadata) {
 			JFFS2_ERROR("Argh. Special inode #%u with mode 0%o had metadata node\n",
 			       f->inocache->ino, jemode_to_cpu(latest_node->mode));
-			mutex_unlock(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			return -EIO;
+			ret = -EIO;
+			goto out;
 		}
 		if (!frag_first(&f->fragtree)) {
 			JFFS2_ERROR("Argh. Special inode #%u with mode 0%o has no fragments\n",
 			       f->inocache->ino, jemode_to_cpu(latest_node->mode));
-			mutex_unlock(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			return -EIO;
+			ret = -EIO;
+			goto out;
 		}
 		/* ASSERT: f->fraglist != NULL */
 		if (frag_next(frag_first(&f->fragtree))) {
 			JFFS2_ERROR("Argh. Special inode #%u with mode 0x%x had more than one node\n",
 			       f->inocache->ino, jemode_to_cpu(latest_node->mode));
 			/* FIXME: Deal with it - check crc32, check for duplicate node, check times and discard the older one */
-			mutex_unlock(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			return -EIO;
+			ret = -EIO;
+			goto out;
 		}
 		/* OK. We're happy */
 		f->metadata = frag_first(&f->fragtree)->node;
@@ -1317,8 +1308,13 @@ static int jffs2_do_read_inode_internal(
 	}
 	if (f->inocache->state == INO_STATE_READING)
 		jffs2_set_inocache_state(c, f->inocache, INO_STATE_PRESENT);
-
-	return 0;
+out:
+	if (ret) {
+		mutex_unlock(&f->sem);
+		jffs2_do_clear_inode(c, f);
+		mutex_lock(&f->sem);
+	}
+	return ret;
 }
 
 /* Scan the list of all nodes present for this ino, build map of versions, etc. */
@@ -1400,10 +1396,9 @@ int jffs2_do_crccheck_inode(struct jffs2
 	f->inocache = ic;
 
 	ret = jffs2_do_read_inode_internal(c, f, &n);
-	if (!ret) {
-		mutex_unlock(&f->sem);
+	mutex_unlock(&f->sem);
+	if (!ret)
 		jffs2_do_clear_inode(c, f);
-	}
 	jffs2_xattr_do_crccheck_inode(c, ic);
 	kfree (f);
 	return ret;
_

Patches currently in -mm which might be from lizefan@huawei.com are

jffs2-fix-unbalanced-locking-v2.patch
jffs2-fix-unbalanced-locking.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
jffs2-remove-wait-queue-after-schedule.patch
linux-next.patch

