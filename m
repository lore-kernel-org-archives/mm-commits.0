From: akpm@osdl.org
Subject: - constify-inode-accessors.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:33 -0800
Message-ID: <200612072301.kB7N1X3r029770@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163765AbWLGXBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     constify inode accessors
has been removed from the -mm tree.  Its filename was
     constify-inode-accessors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: constify inode accessors
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change the signature of i_size_read(), IMINOR() and IMAJOR() because they,
or the functions they call, will never modify the argument.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/fs.h~constify-inode-accessors include/linux/fs.h
--- a/include/linux/fs.h~constify-inode-accessors
+++ a/include/linux/fs.h
@@ -636,7 +636,7 @@ extern void inode_double_unlock(struct i
  * cmpxchg8b without the need of the lock prefix). For SMP compiles
  * and 64bit archs it makes no difference if preempt is enabled or not.
  */
-static inline loff_t i_size_read(struct inode *inode)
+static inline loff_t i_size_read(const struct inode *inode)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	loff_t i_size;
@@ -679,12 +679,12 @@ static inline void i_size_write(struct i
 #endif
 }
 
-static inline unsigned iminor(struct inode *inode)
+static inline unsigned iminor(const struct inode *inode)
 {
 	return MINOR(inode->i_rdev);
 }
 
-static inline unsigned imajor(struct inode *inode)
+static inline unsigned imajor(const struct inode *inode)
 {
 	return MAJOR(inode->i_rdev);
 }
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch

