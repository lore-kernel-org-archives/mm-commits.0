Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D75F3BBFAE;
	Thu,  4 Jun 2026 21:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609804; cv=none; b=r0Lo0mbmj4KsUeVQcfsrpuyBgEbzC8vK2oxu+J0Lx3SK+0FXETKWuf1Ju4uoaAEvdr3wr+OjpNE4bKCg2jJZ/gJ3LGJFG6IOrsSSHuzaUBGO5BPVEsK6kvk3hoFkXFY4LGZrcxoNHXPJBZFsdkgtNpFbC/gJOkGzGLZB2ZERgTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609804; c=relaxed/simple;
	bh=7d6TCybTx7z/fLuRuYdFANx2aQumdGNjZ06RTL1x2Wg=;
	h=Date:To:From:Subject:Message-Id; b=TJ/+zU69FBkM6kF431OVk3rxaFZoLF0+NXkfEY7AX15rL36eyOsCiLLsIRUUmqAruaxg7Bn0SDL0yr08rm2YiO2npr6A/2SwYBFRknxPxyVu1NxKoh98xBnqemKOj4FZhTQrLu2uNE1hkWxaZ175ube+wZNoJtVcWHcFPKFmItE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZzGxy2oI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZzGxy2oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0FC1F00893;
	Thu,  4 Jun 2026 21:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609803;
	bh=A5dV5Cgg54SS1lXbRzOTNOFjXScvZcPmKpVErSlNiNU=;
	h=Date:To:From:Subject;
	b=ZzGxy2oIDE4qUq0vxAWwNWcS66XDDnZJetLyPaqRAx1z4Aj904eWX5Hgdd+x70ymK
	 8wzIWLDjSJ0NaIwQgEdlQhKeQMCsk+pXe/JGQ4ryHY1kPeUYqrt729Ni9OGUHhckuj
	 Z3yBCYrrsialoqBhAEnTxEgJOdgyRq77Ly9GzZUY=
Date: Thu, 04 Jun 2026 14:50:02 -0700
To: mm-commits@vger.kernel.org,tamird@kernel.org,stable@vger.kernel.org,nathan@kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,ansuelsmth@gmail.com,andriy.shevchenko@linux.intel.com,andersson@kernel.org,aleksander.lobakin@intel.com,agordeev@linux.ibm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] errh-use-__always_inline-on-all-error-pointer-helpers.patch removed from -mm tree
Message-Id: <20260604215002.DA0FC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: err.h: use __always_inline on all error pointer helpers
has been removed from the -mm tree.  Its filename was
     errh-use-__always_inline-on-all-error-pointer-helpers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: err.h: use __always_inline on all error pointer helpers
Date: Tue, 26 May 2026 12:18:41 +0200

While testing randconfig builds on s390, I came across a link failure with
CONFIG_DMA_SHARED_BUFFER disabled:

ERROR: modpost: "dma_buf_put" [drivers/iommu/iommufd/iommufd.ko] undefined!

The problem here is that IS_ERR() is not inlined and dead code elimination
fails as a consequence.

The err.h helpers all turn into a trivial assignment of a bit mask and
should never result in a function call, so force them to always be inline.
This should generally result in better object code aside from avoiding
the link failure above.

Link: https://lore.kernel.org/20260526101851.2495110-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Tamir Duberstein <tamird@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ansuel Smith <ansuelsmth@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/err.h~errh-use-__always_inline-on-all-error-pointer-helpers
+++ a/include/linux/err.h
@@ -36,7 +36,7 @@
  *
  * Return: A pointer with @error encoded within its value.
  */
-static inline void * __must_check ERR_PTR(long error)
+static __always_inline void * __must_check ERR_PTR(long error)
 {
 	return (void *) error;
 }
@@ -60,7 +60,7 @@ static inline void * __must_check ERR_PT
  * @ptr: An error pointer.
  * Return: The error code within @ptr.
  */
-static inline long __must_check PTR_ERR(__force const void *ptr)
+static __always_inline long __must_check PTR_ERR(__force const void *ptr)
 {
 	return (long) ptr;
 }
@@ -73,7 +73,7 @@ static inline long __must_check PTR_ERR(
  * @ptr: The pointer to check.
  * Return: true if @ptr is an error pointer, false otherwise.
  */
-static inline bool __must_check IS_ERR(__force const void *ptr)
+static __always_inline bool __must_check IS_ERR(__force const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -87,7 +87,7 @@ static inline bool __must_check IS_ERR(_
  *
  * Like IS_ERR(), but also returns true for a null pointer.
  */
-static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
+static __always_inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
 	return unlikely(!ptr) || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -99,7 +99,7 @@ static inline bool __must_check IS_ERR_O
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void * __must_check ERR_CAST(__force const void *ptr)
+static __always_inline void * __must_check ERR_CAST(__force const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
@@ -122,7 +122,7 @@ static inline void * __must_check ERR_CA
  *
  * Return: The error code within @ptr if it is an error pointer; 0 otherwise.
  */
-static inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
+static __always_inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
_

Patches currently in -mm which might be from arnd@arndb.de are


