From: akpm@linux-foundation.org
Subject: - add-macros-similar-to-min-max-min_t-max_t.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:45 -0700
Message-ID: <200805010932.m419Wj5l031010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757425AbYEAJei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, acme@ghostprotocols.net, akpm@linux-foundation.org, bzolnier@gmail.com, dtor@mail.ru, htejun@gmail.com, jeff@garzik.org, jkosina@suse.cz, linville@tuxdriver


The patch titled
     Add macros similar to min/max/min_t/max_t
has been removed from the -mm tree.  Its filename was
     add-macros-similar-to-min-max-min_t-max_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add macros similar to min/max/min_t/max_t
From: Harvey Harrison <harvey.harrison@gmail.com>

Also, change the variable names used in the min/max macros to avoid shadowed
variable warnings when min/max min_t/max_t are nested.

Small formatting changes to make all the macros have a similar form.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix v4l build]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bt8xx/bttvp.h    |    2 
 drivers/media/video/usbvideo/vicam.c |    6 -
 include/linux/kernel.h               |   91 ++++++++++++++++++++-----
 3 files changed, 74 insertions(+), 25 deletions(-)

diff -puN drivers/media/video/bt8xx/bttvp.h~add-macros-similar-to-min-max-min_t-max_t drivers/media/video/bt8xx/bttvp.h
--- a/drivers/media/video/bt8xx/bttvp.h~add-macros-similar-to-min-max-min_t-max_t
+++ a/drivers/media/video/bt8xx/bttvp.h
@@ -81,8 +81,6 @@
 /* Limits scaled width, which must be a multiple of 4. */
 #define MAX_HACTIVE (0x3FF & -4)
 
-#define clamp(x, low, high) min (max (low, x), high)
-
 #define BTTV_NORMS    (\
 		V4L2_STD_PAL    | V4L2_STD_PAL_N | \
 		V4L2_STD_PAL_Nc | V4L2_STD_SECAM | \
diff -puN drivers/media/video/usbvideo/vicam.c~add-macros-similar-to-min-max-min_t-max_t drivers/media/video/usbvideo/vicam.c
--- a/drivers/media/video/usbvideo/vicam.c~add-macros-similar-to-min-max-min_t-max_t
+++ a/drivers/media/video/usbvideo/vicam.c
@@ -70,12 +70,6 @@
 
 #define VICAM_HEADER_SIZE       64
 
-#define clamp( x, l, h )        max_t( __typeof__( x ),         \
-				       ( l ),                   \
-				       min_t( __typeof__( x ),  \
-					      ( h ),            \
-					      ( x ) ) )
-
 /* Not sure what all the bytes in these char
  * arrays do, but they're necessary to make
  * the camera work.
diff -puN include/linux/kernel.h~add-macros-similar-to-min-max-min_t-max_t include/linux/kernel.h
--- a/include/linux/kernel.h~add-macros-similar-to-min-max-min_t-max_t
+++ a/include/linux/kernel.h
@@ -338,33 +338,90 @@ extern void print_hex_dump_bytes(const c
 #endif /* __LITTLE_ENDIAN */
 
 /*
- * min()/max() macros that also do
+ * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
  */
-#define min(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x < _y ? _x : _y; })
-
-#define max(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x > _y ? _x : _y; })
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+
+#define max(x, y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+
+/**
+ * clamp - return a value clamped to a given range with strict typechecking
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does strict typechecking of min/max to make sure they are of the
+ * same type as val.  See the unnecessary pointer comparisons.
+ */
+#define clamp(val, min, max) ({			\
+	typeof(val) __val = (val);		\
+	typeof(min) __min = (min);		\
+	typeof(max) __max = (max);		\
+	(void) (&__val == &__min);		\
+	(void) (&__val == &__max);		\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
 
 /*
  * ..and if you can't take the strict
  * types, you can specify one yourself.
  *
- * Or not use min/max at all, of course.
+ * Or not use min/max/clamp at all, of course.
  */
-#define min_t(type,x,y) \
-	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
-#define max_t(type,x,y) \
-	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
+#define min_t(type, x, y) ({			\
+	type __min1 = (x);			\
+	type __min2 = (y);			\
+	__min1 < __min2 ? __min1: __min2; })
+
+#define max_t(type, x, y) ({			\
+	type __max1 = (x);			\
+	type __max2 = (y);			\
+	__max1 > __max2 ? __max1: __max2; })
 
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
+#define clamp_t(type, val, min, max) ({		\
+	type __val = (val);			\
+	type __min = (min);			\
+	type __max = (max);			\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
+
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
+#define clamp_val(val, min, max) ({		\
+	typeof(val) __val = (val);		\
+	typeof(val) __min = (min);		\
+	typeof(val) __max = (max);		\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
 
 /**
  * container_of - cast a member of a structure out to the containing structure
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

