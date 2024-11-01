Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D50136337
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 02:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730427496; cv=none; b=tswYg0Ik1fRcMcV1n/p/dXLjW5P8SHRRX24VJPe2IX/Y0vjTfk87s7HNEuqt0uw/Zyebo1GZQCJVbb8nA42w76yKLV5+NOuRInkgeHVWlwp0oUnEMRtHIh+hYcCFDDgWAPbfGrLFGjFUDQgZXlIymY/7cAWycDVa3bASfKpB7Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730427496; c=relaxed/simple;
	bh=mep6ZMGEDTwRUok1/89KTY3mRHliUAtIJQreZkcYP2w=;
	h=Date:To:From:Subject:Message-Id; b=fGnXE80YufbYgg8XFzvKsHtIJHAg2pNed/MByOUxDLnmx+zNRzzhO6f3l+3PQvK6476AXQJJQcQZ8Whdn6hg5D1XS/5P7PBorjeb3oTbcuR337vcWXySvh3m4QIfdJ0wreLls/sMxmmYiZBtq+tNWKuyq3o2wDOx29e9m5GSCDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dZ3iSyHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dZ3iSyHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C61C4CEC3;
	Fri,  1 Nov 2024 02:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730427496;
	bh=mep6ZMGEDTwRUok1/89KTY3mRHliUAtIJQreZkcYP2w=;
	h=Date:To:From:Subject:From;
	b=dZ3iSyHoUtX2FE0YJizZxFPcWrbUYT3k6+flMI2GIjMej0Sc3Ha3ebHcfht6O8UkR
	 uyzNDfzc2koLgGee4JdJCNrky3S2KwHjxYeGegNl9wRUoeLYPE4qTvgaAqVhGsGc1i
	 +MPyQxCbR+I2bR+fY9vM/NvyOs4DD/PfrFYwXwNw=
Date: Thu, 31 Oct 2024 19:18:15 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,bartosz.golaszewski@linaro.org,aardelean@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + util_macrosh-fix-rework-find_closest-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20241101021816.55C61C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: util_macros.h: fix/rework find_closest() macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     util_macrosh-fix-rework-find_closest-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/util_macrosh-fix-rework-find_closest-macros.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexandru Ardelean <aardelean@baylibre.com>
Subject: util_macros.h: fix/rework find_closest() macros
Date: Thu, 31 Oct 2024 08:37:06 +0200

A bug was found in the find_closest() (find_closest_descending() is also
affected after some testing), where for certain values with small
progressions, the rounding (done by averaging 2 values) causes an
incorrect index to be returned.  The rounding issues occur for
progressions of 1, 2 and 3.  It goes away when the progression/interval
between two values is 4 or larger.

It's particularly bad for progressions of 1.  For example if there's an
array of 'a = { 1, 2, 3 }', using 'find_closest(2, a ...)' would return 0
(the index of '1'), rather than returning 1 (the index of '2').  This
means that for exact values (with a progression of 1), find_closest() will
misbehave and return the index of the value smaller than the one we're
searching for.

For progressions of 2 and 3, the exact values are obtained correctly; but
values aren't approximated correctly (as one would expect).  Starting with
progressions of 4, all seems to be good.

This change reworks the find_closest(x,) macros to also check the
difference between the left and right elements when 'x'.  If the distance
to the right is smaller (than the distance to the left), the index is
incremented by 1.  This also makes redundant the need for using the
DIV_ROUND_CLOSEST() macro.

For find_closest_descending(), the operator was changed from '>=' to '>'. 
Since the iteration is happening from the highest-to-lowest values, the
'>=' comparison would (for small progressions) prefer higher values (as
closer to the given values).

For example:
  Given array 'a[] = { 10, 7, 4, 1 };'
     find_closest_descending(2, a,...) returns the index[2] for 4
     find_closest_descending(5, a,...) returns the index[1] for 7
     find_closest_descending(8, a,...) returns the index[0] for 10

Link: https://lkml.kernel.org/r/20241031063707.795842-1-aardelean@baylibre.com
Signed-off-by: Alexandru Ardelean <aardelean@baylibre.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/include/linux/util_macros.h~util_macrosh-fix-rework-find_closest-macros
+++ a/include/linux/util_macros.h
@@ -7,12 +7,18 @@
 #define __find_closest(x, a, as, op)					\
 ({									\
 	typeof(as) __fc_i, __fc_as = (as) - 1;				\
-	typeof(x) __fc_x = (x);						\
+	typeof(x) __fc_mid_x, __fc_x = (x);				\
+	typeof(x) __fc_left, __fc_right;				\
 	typeof(*a) const *__fc_a = (a);					\
 	for (__fc_i = 0; __fc_i < __fc_as; __fc_i++) {			\
-		if (__fc_x op DIV_ROUND_CLOSEST(__fc_a[__fc_i] +	\
-						__fc_a[__fc_i + 1], 2))	\
+		__fc_mid_x = (__fc_a[__fc_i] + __fc_a[__fc_i + 1]) / 2;	\
+		if (__fc_x op __fc_mid_x) {				\
+			__fc_left = __fc_mid_x - __fc_a[__fc_i];	\
+			__fc_right = __fc_a[__fc_i + 1] - __fc_mid_x;	\
+			if (__fc_right < __fc_left)			\
+				__fc_i++;				\
 			break;						\
+		}							\
 	}								\
 	(__fc_i);							\
 })
@@ -38,7 +44,7 @@
  * Similar to find_closest() but 'a' is expected to be sorted in descending
  * order.
  */
-#define find_closest_descending(x, a, as) __find_closest(x, a, as, >=)
+#define find_closest_descending(x, a, as) __find_closest(x, a, as, >)
 
 /**
  * is_insidevar - check if the @ptr points inside the @var memory range.
_

Patches currently in -mm which might be from aardelean@baylibre.com are

util_macrosh-fix-rework-find_closest-macros.patch
lib-util_macros_kunit-add-kunit-test-for-util_macrosh.patch

