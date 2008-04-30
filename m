From: akpm@linux-foundation.org
Subject: - add-macros-similar-to-min-max-min_t-max_t-doc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:25:21 -0700
Message-ID: <200804300625.m3U6PLoj031721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865AbYD3G0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     add kerneldoc for clamp(), clamp_t(), clamp_val() macros
has been removed from the -mm tree.  Its filename was
     add-macros-similar-to-min-max-min_t-max_t-doc.patch

This patch was dropped because it was folded into add-macros-similar-to-min-max-min_t-max_t.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add kerneldoc for clamp(), clamp_t(), clamp_val() macros
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN include/linux/kernel.h~add-macros-similar-to-min-max-min_t-max_t-doc include/linux/kernel.h
--- a/include/linux/kernel.h~add-macros-similar-to-min-max-min_t-max_t-doc
+++ a/include/linux/kernel.h
@@ -354,6 +354,15 @@ extern void print_hex_dump_bytes(const c
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+/**
+ * clamp - return a value clamped to a given range with strict typechecking
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does strict typechecking of min/max to make sure they are of the
+ * same type as val.  See the unnecessary pointer comparisons.
+ */
 #define clamp(val, min, max) ({			\
 	typeof(val) __val = (val);		\
 	typeof(min) __min = (min);		\
@@ -379,6 +388,16 @@ extern void print_hex_dump_bytes(const c
 	type __max2 = (y);			\
 	__max1 > __max2 ? __max1: __max2; })
 
+/**
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * 'type' to make all the comparisons.
+ */
 #define clamp_t(type, val, min, max) ({		\
 	type __val = (val);			\
 	type __min = (min);			\
@@ -386,6 +405,17 @@ extern void print_hex_dump_bytes(const c
 	__val = __val < __min ? __min: __val;	\
 	__val > __max ? __max: __val; })
 
+/**
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument 'val' is.  This is useful when val is an unsigned
+ * type and min and max are literals that will otherwise be assigned a signed
+ * integer type.
+ */
 #define clamp_val(val, min, max) ({		\
 	typeof(val) __val = (val);		\
 	typeof(val) __min = (min);		\
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

