From: akpm@linux-foundation.org
Subject: +
 security-smack-replace-kzalloc-with-kmem_cache-for-inode_smack.patch added
 to -mm tree
Date: Wed, 15 Oct 2014 12:55:21 -0700
Message-ID: <543ed129.QC5q9ZI2HHF7U5pI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaJOTzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 15:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rohit.kr@samsung.com, casey@schaufler-ca.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Security: smack: replace kzalloc with kmem_cache for inode_smack
has been added to the -mm tree.  Its filename is
     security-smack-replace-kzalloc-with-kmem_cache-for-inode_smack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/security-smack-replace-kzalloc-with-kmem_cache-for-inode_smack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/security-smack-replace-kzalloc-with-kmem_cache-for-inode_smack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rohit <rohit.kr@samsung.com>
Subject: Security: smack: replace kzalloc with kmem_cache for inode_smack

The patch use kmem_cache to allocate/free inode_smack since they are
alloced in high volumes making it a perfect case for kmem_cache.

As per analysis, 24 bytes of memory is wasted per allocation due
to internal fragmentation. With kmem_cache, this can be avoided.

Accounting of memory allocation is below :
 total       slack            net      count-alloc/free        caller
Before (with kzalloc)
1919872      719952          1919872      29998/0          new_inode_smack+0x14

After (with kmem_cache)
1201680          0           1201680      30042/0          new_inode_smack+0x18

Via the above data we found that 719952 bytes(~700 KB) of memory is saved
on allocation of 29998 smack inodes.

Signed-off-by: Rohit <rohit.kr@samsung.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN security/smack/smack_lsm.c~security-smack-replace-kzalloc-with-kmem_cache-for-inode_smack security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~security-smack-replace-kzalloc-with-kmem_cache-for-inode_smack
+++ a/security/smack/smack_lsm.c
@@ -53,6 +53,7 @@
 #define SMK_SENDING	2
 
 LIST_HEAD(smk_ipv6_port_list);
+static struct kmem_cache *smack_inode_cache;
 
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
 static void smk_bu_mode(int mode, char *s)
@@ -240,7 +241,7 @@ struct inode_smack *new_inode_smack(stru
 {
 	struct inode_smack *isp;
 
-	isp = kzalloc(sizeof(struct inode_smack), GFP_NOFS);
+	isp = kmem_cache_zalloc(smack_inode_cache, GFP_NOFS);
 	if (isp == NULL)
 		return NULL;
 
@@ -767,7 +768,7 @@ static int smack_inode_alloc_security(st
  */
 static void smack_inode_free_security(struct inode *inode)
 {
-	kfree(inode->i_security);
+	kmem_cache_free(smack_inode_cache, inode->i_security);
 	inode->i_security = NULL;
 }
 
@@ -4264,10 +4265,16 @@ static __init int smack_init(void)
 	if (!security_module_enable(&smack_ops))
 		return 0;
 
+	smack_inode_cache = KMEM_CACHE(inode_smack, 0);
+	if (!smack_inode_cache)
+		return -ENOMEM;
+
 	tsp = new_task_smack(&smack_known_floor, &smack_known_floor,
 				GFP_KERNEL);
-	if (tsp == NULL)
+	if (tsp == NULL) {
+		kmem_cache_destroy(smack_inode_cache);
 		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "Smack:  Initializing.\n");
 
_

Patches currently in -mm which might be from rohit.kr@samsung.com are

security-smack-replace-kzalloc-with-kmem_cache-for-inode_smack.patch

