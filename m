Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63631EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676277; cv=none; b=HNaLFsTtM72n+L+u/hnbvQ+yUKNU/S1FrUxl4jLZwB7qzoiCyiwGujoaDxTVuivAv8aflKy4yMnJMoPfHeVt9mqQsb7nMcE/5ajEq/Si/FFNMraf2lb+G5v/QMdrQ6xhRPsTmsC7S4atlwdrf2Vm1Opf8rtqxEAnpdLQSOXNtOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676277; c=relaxed/simple;
	bh=h3AEZgrd5cR6q7RIrBplpK786wseoBSPjazPwPv5cPk=;
	h=Date:To:From:Subject:Message-Id; b=PKoRywiLddgOrdXBoavS334pbZ56q4qI2MO+M8qcqzIRWJ5cb4PaORUq2lbvLX3vcdvqjED0qiRxPmvGCC+ic6QpPr7ZLWdXrlqpz2B36rirEPaXg9MhUnzk8PTGUG7kyolUFTZMZVANss4OEfP/6Tn4xmMd6nouFE0dEA6i8vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mobvcoUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mobvcoUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CDCC4CEF1;
	Thu, 20 Nov 2025 22:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676276;
	bh=h3AEZgrd5cR6q7RIrBplpK786wseoBSPjazPwPv5cPk=;
	h=Date:To:From:Subject:From;
	b=mobvcoUTPP3WDcv43/UxnLMM7MAImtgYS9w/JHeBzcGZaU1qDF2w8lV9yDclWLFZE
	 FfksmmeKEP461P0UmI/HEI+DYawx76kdG1eb+SxXNTKswjjwuTBb0LVCfnyl/jMb3G
	 iZqX0jT2ioSkGxTN5KrrmRrVwb8geuM6C71Y7po0=
Date: Thu, 20 Nov 2025 14:04:35 -0800
To: mm-commits@vger.kernel.org,jic23@kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mathh-amend-kernel-doc-and-add-a-note-about-signed-type-limits.patch removed from -mm tree
Message-Id: <20251120220436.59CDCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: math.h: amend abs() kernel-doc and add a note about signed type limits
has been removed from the -mm tree.  Its filename was
     mathh-amend-kernel-doc-and-add-a-note-about-signed-type-limits.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: math.h: amend abs() kernel-doc and add a note about signed type limits
Date: Thu, 6 Nov 2025 16:20:51 +0100

- amend the kernel-doc so the description is decoupled from the
  parameter descriptions.

- add a note to explain behaviour for the signed types when supplied
  value is the minimum (e.g., INT_MIN for int type).

Link: https://lkml.kernel.org/r/20251106152051.2361551-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/math.h~mathh-amend-kernel-doc-and-add-a-note-about-signed-type-limits
+++ a/include/linux/math.h
@@ -148,11 +148,16 @@ __STRUCT_FRACT(u32)
 
 /**
  * abs - return absolute value of an argument
- * @x: the value.  If it is unsigned type, it is converted to signed type first.
- *     char is treated as if it was signed (regardless of whether it really is)
- *     but the macro's return type is preserved as char.
+ * @x: the value.
  *
- * Return: an absolute value of x.
+ * If it is unsigned type, @x is converted to signed type first.
+ * char is treated as if it was signed (regardless of whether it really is)
+ * but the macro's return type is preserved as char.
+ *
+ * NOTE, for signed type if @x is the minimum, the returned result is undefined
+ * as there is not enough bits to represent it as a positive number.
+ *
+ * Return: an absolute value of @x.
  */
 #define abs(x)	__abs_choose_expr(x, long long,				\
 		__abs_choose_expr(x, long,				\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


