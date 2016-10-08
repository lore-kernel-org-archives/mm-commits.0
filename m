From: akpm@linux-foundation.org
Subject: [patch 116/127] min/max: remove sparse warnings when they're
 nested
Date: Fri, 07 Oct 2016 17:02:42 -0700
Message-ID: <57f837a2.btDtuqyarV70Vybd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754756AbcJHACo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, johannes.berg@intel.com, axboe@kernel.dk

From: Johannes Berg <johannes.berg@intel.com>
Subject: min/max: remove sparse warnings when they're nested

Currently, when min/max are nested within themselves, sparse will warn:

    warning: symbol '_min1' shadows an earlier one
    originally declared here
    warning: symbol '_min1' shadows an earlier one
    originally declared here
    warning: symbol '_min2' shadows an earlier one
    originally declared here

This also immediately happens when min3() or max3() are used.

Since sparse implements __COUNTER__, we can use __UNIQUE_ID() to generate
unique variable names, avoiding this.

Link: http://lkml.kernel.org/r/1471519773-29882-1-git-send-email-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   48 ++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff -puN include/linux/kernel.h~min-max-remove-sparse-warnings-when-theyre-nested include/linux/kernel.h
--- a/include/linux/kernel.h~min-max-remove-sparse-warnings-when-theyre-nested
+++ a/include/linux/kernel.h
@@ -733,17 +733,25 @@ static inline void ftrace_dump(enum ftra
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
  */
-#define min(x, y) ({				\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
-
-#define max(x, y) ({				\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	(void) (&_max1 == &_max2);		\
-	_max1 > _max2 ? _max1 : _max2; })
+#define __min(t1, t2, min1, min2, x, y) ({		\
+	t1 min1 = (x);					\
+	t2 min2 = (y);					\
+	(void) (&min1 == &min2);			\
+	min1 < min2 ? min1 : min2; })
+#define min(x, y)					\
+	__min(typeof(x), typeof(y),			\
+	      __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),	\
+	      x, y)
+
+#define __max(t1, t2, max1, max2, x, y) ({		\
+	t1 max1 = (x);					\
+	t2 max2 = (y);					\
+	(void) (&max1 == &max2);			\
+	max1 > max2 ? max1 : max2; })
+#define max(x, y)					\
+	__max(typeof(x), typeof(y),			\
+	      __UNIQUE_ID(max1_), __UNIQUE_ID(max2_),	\
+	      x, y)
 
 #define min3(x, y, z) min((typeof(x))min(x, y), z)
 #define max3(x, y, z) max((typeof(x))max(x, y), z)
@@ -775,15 +783,15 @@ static inline void ftrace_dump(enum ftra
  *
  * Or not use min/max/clamp at all, of course.
  */
-#define min_t(type, x, y) ({			\
-	type __min1 = (x);			\
-	type __min2 = (y);			\
-	__min1 < __min2 ? __min1: __min2; })
