From: akpm@linux-foundation.org
Subject: [patch 093/108] mm: kmemleak: factor object reference
 updating out of scan_block()
Date: Thu, 06 Jul 2017 15:40:19 -0700
Message-ID: <20170706224019.5YRiLnxGV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752975AbdGFWkU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, luto@amacapital.net, mcgrof@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: factor object reference updating out of scan_block()

scan_block() updates the number of references (pointers) to objects,
adding them to the gray_list when object->min_count is reached.  The patch
factors out this functionality into a separate update_refs() function.

Link: http://lkml.kernel.org/r/1495726937-23557-3-git-send-email-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-factor-object-reference-updating-out-of-scan_block mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-factor-object-reference-updating-out-of-scan_block
+++ a/mm/kmemleak.c
@@ -1188,6 +1188,30 @@ static bool update_checksum(struct kmeml
 }
 
 /*
+ * Update an object's references. object->lock must be held by the caller.
+ */
+static void update_refs(struct kmemleak_object *object)
+{
+	if (!color_white(object)) {
+		/* non-orphan, ignored or new */
+		return;
+	}
+
+	/*
+	 * Increase the object's reference count (number of pointers to the
+	 * memory block). If this count reaches the required minimum, the
+	 * object's color will become gray and it will be added to the
+	 * gray_list.
+	 */
+	object->count++;
+	if (color_gray(object)) {
+		/* put_object() called when removing from gray_list */
+		WARN_ON(!get_object(object));
+		list_add_tail(&object->gray_list, &gray_list);
+	}
+}
+
+/*
  * Memory scanning is a long process and it needs to be interruptable. This
  * function checks whether such interrupt condition occurred.
  */
@@ -1259,24 +1283,7 @@ static void scan_block(void *_start, voi
 		 * enclosed by scan_mutex.
 		 */
 		spin_lock_nested(&object->lock, SINGLE_DEPTH_NESTING);
-		if (!color_white(object)) {
-			/* non-orphan, ignored or new */
-			spin_unlock(&object->lock);
-			continue;
-		}
