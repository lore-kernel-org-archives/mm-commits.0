From: akpm@linux-foundation.org
Subject: +
 drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch added to -mm tree
Date: Thu, 07 Nov 2013 14:16:57 -0800
Message-ID: <527c1159.kf7XXYp4ZPa5jurk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3KGWQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, jack@suse.cz, dwmw2@infradead.org, dedekind1@gmail.com, cody@linux.vnet.ibm.com

Subject: + drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch added to -mm tree
To: cody@linux.vnet.ibm.com,dedekind1@gmail.com,dwmw2@infradead.org,jack@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:57 -0800


The patch titled
     Subject: drivers/mtd/ubi: use rbtree postorder iteration helper instead of opencoding
has been added to the -mm tree.  Its filename is
     drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: drivers/mtd/ubi: use rbtree postorder iteration helper instead of opencoding

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/ubi/attach.c |   47 ++++---------------------------------
 drivers/mtd/ubi/wl.c     |   25 ++-----------------
 2 files changed, 9 insertions(+), 63 deletions(-)

diff -puN drivers/mtd/ubi/attach.c~drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding drivers/mtd/ubi/attach.c
--- a/drivers/mtd/ubi/attach.c~drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/drivers/mtd/ubi/attach.c
@@ -1132,27 +1132,11 @@ static int late_analysis(struct ubi_devi
  */
 static void destroy_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
 {
-	struct ubi_ainf_peb *aeb;
-	struct rb_node *this = av->root.rb_node;
+	struct ubi_ainf_peb *aeb, *next;
 
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			aeb = rb_entry(this, struct ubi_ainf_peb, u.rb);
-			this = rb_parent(this);
-			if (this) {
-				if (this->rb_left == &aeb->u.rb)
-					this->rb_left = NULL;
-				else
-					this->rb_right = NULL;
-			}
+	rbtree_postorder_for_each_entry_safe(aeb, next, &av->root, u.rb)
+		kmem_cache_free(ai->aeb_slab_cache, aeb);
 
-			kmem_cache_free(ai->aeb_slab_cache, aeb);
-		}
-	}
 	kfree(av);
 }
 
@@ -1163,8 +1147,7 @@ static void destroy_av(struct ubi_attach
 static void destroy_ai(struct ubi_attach_info *ai)
 {
 	struct ubi_ainf_peb *aeb, *aeb_tmp;
-	struct ubi_ainf_volume *av;
-	struct rb_node *rb;
+	struct ubi_ainf_volume *av, *next;
 
 	list_for_each_entry_safe(aeb, aeb_tmp, &ai->alien, u.list) {
 		list_del(&aeb->u.list);
@@ -1184,26 +1167,8 @@ static void destroy_ai(struct ubi_attach
 	}
 
 	/* Destroy the volume RB-tree */
-	rb = ai->volumes.rb_node;
-	while (rb) {
-		if (rb->rb_left)
-			rb = rb->rb_left;
-		else if (rb->rb_right)
-			rb = rb->rb_right;
-		else {
-			av = rb_entry(rb, struct ubi_ainf_volume, rb);
-
-			rb = rb_parent(rb);
-			if (rb) {
-				if (rb->rb_left == &av->rb)
-					rb->rb_left = NULL;
-				else
-					rb->rb_right = NULL;
-			}
-
-			destroy_av(ai, av);
-		}
-	}
+	rbtree_postorder_for_each_entry_safe(av, next, &ai->volumes, rb)
+		destroy_av(ai, av);
 
 	if (ai->aeb_slab_cache)
 		kmem_cache_destroy(ai->aeb_slab_cache);
diff -puN drivers/mtd/ubi/wl.c~drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding drivers/mtd/ubi/wl.c
--- a/drivers/mtd/ubi/wl.c~drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/drivers/mtd/ubi/wl.c
@@ -1756,29 +1756,10 @@ int ubi_wl_flush(struct ubi_device *ubi,
  */
 static void tree_destroy(struct rb_root *root)
 {
-	struct rb_node *rb;
-	struct ubi_wl_entry *e;
+	struct ubi_wl_entry *e, *next;
 
-	rb = root->rb_node;
-	while (rb) {
-		if (rb->rb_left)
-			rb = rb->rb_left;
-		else if (rb->rb_right)
-			rb = rb->rb_right;
-		else {
-			e = rb_entry(rb, struct ubi_wl_entry, u.rb);
-
-			rb = rb_parent(rb);
-			if (rb) {
-				if (rb->rb_left == &e->u.rb)
-					rb->rb_left = NULL;
-				else
-					rb->rb_right = NULL;
-			}
-
-			kmem_cache_free(ubi_wl_entry_slab, e);
-		}
-	}
+	rbtree_postorder_for_each_entry_safe(e, next, root, u.rb)
+		kmem_cache_free(ubi_wl_entry_slab, e);
 }
 
 /**
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

bitops-find-clarify-and-extend-documentation.patch
linux-next.patch
rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch

