Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383F81A83F7
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011380; cv=none; b=bLXHU5Th6cHdYYuPm8pbZeVPuvHN5zYct+oIKyi5QpNy/6c5aLU1Fkm8Hjy9+6Jxnb3xfZaOqOjQauOMVlUZh/Zg5YUhn31zn1euKjbUGgj9pSkdRzqQm//hLbp3esynMc2VLohvIbAPR7v/CrVgujfYipObQUaykTiyLKVKw1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011380; c=relaxed/simple;
	bh=MfK4F+3xeBKraBPFvgz+n7uC+PnlFXx3m8ifJpMHWoI=;
	h=Date:To:From:Subject:Message-Id; b=ecnCGI4MKF9QNKaxPM/DheCcYXbkF15KHd4+Q6Jyp5Y4oh5Z53nf569578npABMX6hai7qXAoxHk3V3tOkqtbwFhgP0z/6+v6lY/UFNOC5Q1aMGqHQXfaIEoxKqku9HEa6+Ug3RryQdOra7QECRiC/a537sVUvZCQsFQbkweFMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T2rUWDSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T2rUWDSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC99C4CEE4;
	Mon, 12 May 2025 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011380;
	bh=MfK4F+3xeBKraBPFvgz+n7uC+PnlFXx3m8ifJpMHWoI=;
	h=Date:To:From:Subject:From;
	b=T2rUWDSfcSnSAS5NKoOIoy6yhkDiUhyXrrzcsOw76o/5M/O2RBNWdgiJfTiIDz4WD
	 6utZdQ/CTtRf8CZyWg1gmVPrWEPm4H6VRlWHwGcGOrFKp4GcTfWmVnJQjN8BfGqitO
	 L3pT3MpX+nCHOgiQ07xQ+hXrew3xwG+U5yyOLOrA=
Date: Sun, 11 May 2025 17:56:19 -0700
To: mm-commits@vger.kernel.org,aardelean@baylibre.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] util_macrosh-fix-the-reference-in-kernel-doc.patch removed from -mm tree
Message-Id: <20250512005620.0DC99C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: util_macros.h: fix the reference in kernel-doc
has been removed from the -mm tree.  Its filename was
     util_macrosh-fix-the-reference-in-kernel-doc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: util_macros.h: fix the reference in kernel-doc
Date: Mon, 28 Apr 2025 10:27:37 +0300

In PTR_IF() description the text refers to the parameter as (ptr) while
the kernel-doc format asks for @ptr.  Fix this accordingly.

Link: https://lkml.kernel.org/r/20250428072737.3265239-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexandru Ardelean <aardelean@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/util_macros.h~util_macrosh-fix-the-reference-in-kernel-doc
+++ a/include/linux/util_macros.h
@@ -85,7 +85,7 @@
  * @ptr: A pointer to assign if @cond is true.
  *
  * PTR_IF(IS_ENABLED(CONFIG_FOO), ptr) evaluates to @ptr if CONFIG_FOO is set
- * to 'y' or 'm', or to NULL otherwise. The (ptr) argument must be a pointer.
+ * to 'y' or 'm', or to NULL otherwise. The @ptr argument must be a pointer.
  *
  * The macro can be very useful to help compiler dropping dead code.
  *
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

util_macrosh-make-the-header-more-resilient.patch

