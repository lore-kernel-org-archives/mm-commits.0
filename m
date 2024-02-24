Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28FBEDE
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 00:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708734392; cv=none; b=BMXJ14/+LT8MMVS+Z7oSqc6N1fEhjjx81MzEsyTlbY52X+u2mH8x4iYb0tQP3RA9orWomVYf/78QKM5lB94azOCL7KElIiy4udk5Zb4pKg11F0kg7TRfdL0ftblXZoFIWeIbl6YtdXDm+nFhCYmrw4eXq/28dANSepyDaIDcMp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708734392; c=relaxed/simple;
	bh=wYmQH0EWzo8ZcT+nh4ry2CzA07kT3IyQzhaozrLeRnM=;
	h=Date:To:From:Subject:Message-Id; b=V+PyTcSa9ch93ZZ2XkHMFm7rmC5dH/Q6XkxHwmDGyXPlDZFEvyd+UsTBmqKWpj+QvhkdqTK4Ni/Swg47V1V1LP0VhMC99LjpMqGh+/DQrkQmmCa9ZTi9RI2Qjn0Mi0YWR9L5otYG1Ce99TdsAIZDOgkQYokXhoEaD74eS4IH5Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0g116cLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0g116cLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47257C433C7;
	Sat, 24 Feb 2024 00:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708734392;
	bh=wYmQH0EWzo8ZcT+nh4ry2CzA07kT3IyQzhaozrLeRnM=;
	h=Date:To:From:Subject:From;
	b=0g116cLtvE9C975Ok9mjVdYASc0AKV+G8JZoxkg5HNH08Wt/ZMc3y842Hlrx6A6dP
	 sPRwUJUQiHj5CTgw2FjDhCZHo7I27RNTi8c995zt1xBq3vSAOMs3gh4/SStotnOkTO
	 ckVLhWgHq7Ev0TV0OcSuNxR0zKAR4yX8itx3VWU0=
Date: Fri, 23 Feb 2024 16:26:31 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-fix-typos-in-kernel-doc.patch added to mm-nonmm-unstable branch
Message-Id: <20240224002632.47257C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfifo: fix typos in kernel-doc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-fix-typos-in-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-fix-typos-in-kernel-doc.patch

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
From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: kfifo: fix typos in kernel-doc
Date: Fri, 23 Feb 2024 12:51:55 +0100

Obviously:
"This macro finish" -> "This macro finishes"
and similar.

Link: https://lkml.kernel.org/r/20240223115155.8806-5-jirislaby@kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/kfifo.h~kfifo-fix-typos-in-kernel-doc
+++ a/include/linux/kfifo.h
@@ -584,7 +584,7 @@ __kfifo_uint_must_check_helper( \
  * @buf: pointer to the storage buffer
  * @n: max. number of elements to get
  *
- * This macro get some data from the fifo and return the numbers of elements
+ * This macro gets some data from the fifo and returns the numbers of elements
  * copied.
  *
  * Note that with only one concurrent reader and one concurrent
@@ -611,7 +611,7 @@ __kfifo_uint_must_check_helper( \
  * @n: max. number of elements to get
  * @lock: pointer to the spinlock to use for locking
  *
- * This macro get the data from the fifo and return the numbers of elements
+ * This macro gets the data from the fifo and returns the numbers of elements
  * copied.
  */
 #define	kfifo_out_spinlocked(fifo, buf, n, lock) \
@@ -739,7 +739,7 @@ __kfifo_int_must_check_helper( \
  * @fifo: address of the fifo to be used
  * @len: number of bytes to received
  *
- * This macro finish a DMA IN operation. The in counter will be updated by
+ * This macro finishes a DMA IN operation. The in counter will be updated by
  * the len parameter. No error checking will be done.
  *
  * Note that with only one concurrent reader and one concurrent
@@ -790,7 +790,7 @@ __kfifo_int_must_check_helper( \
  * @fifo: address of the fifo to be used
  * @len: number of bytes transferred
  *
- * This macro finish a DMA OUT operation. The out counter will be updated by
+ * This macro finishes a DMA OUT operation. The out counter will be updated by
  * the len parameter. No error checking will be done.
  *
  * Note that with only one concurrent reader and one concurrent
@@ -807,7 +807,7 @@ __kfifo_int_must_check_helper( \
  * @buf: pointer to the storage buffer
  * @n: max. number of elements to get
  *
- * This macro get the data from the fifo and return the numbers of elements
+ * This macro gets the data from the fifo and returns the numbers of elements
  * copied. The data is not removed from the fifo.
  *
  * Note that with only one concurrent reader and one concurrent
_

Patches currently in -mm which might be from jirislaby@kernel.org are

kfifo-drop-__kfifo_dma_out_finish_r.patch
kfifo-introduce-and-use-kfifo_skip_count.patch
kfifo-add-kfifo_out_linear_ptr.patch
kfifo-fix-typos-in-kernel-doc.patch

