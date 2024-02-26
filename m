Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFF412CDA2
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 17:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967183; cv=none; b=vEnlbwvJqMfBO9eZSqTO+YwFbygWrmKDscYXT/DafDr1pQDphMzdIbkGdEdB9lz7EAsXuAA3FdKNG85wJGwaijPPQQZ0IB5Fuuj7qHeiAXNC8taqMKhlacfweEUa2KYy4UZqItYpMaD8MGl/hhgqqEDh0k0pBP+G14BqTGn6NWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967183; c=relaxed/simple;
	bh=nHrLTegrF/nLxIK013FBazjIw0IfjiRNszzLdA4D6ak=;
	h=Date:To:From:Subject:Message-Id; b=ZOIDYhUFZQ6ZDTcdugjLBTKiSaNCPIh8levSmVxnTE35GyD8XFqmdZsjgboc6365TBIrxlabPBU8QOwFLyZ+EJ497cTU0OSi9hD2VfLtNsmVy0SQfYpysSX8V0umZ8Gr26EbqasCQL12NZ9gVqf4CP+1ecqlq3S/n86J01L3iOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X+uxHALN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X+uxHALN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A858CC43394;
	Mon, 26 Feb 2024 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708967182;
	bh=nHrLTegrF/nLxIK013FBazjIw0IfjiRNszzLdA4D6ak=;
	h=Date:To:From:Subject:From;
	b=X+uxHALNnYQmnC6i38OGK3bF9UIg4ule0X5SVAmQSq1369URNIsoiECQiak5wDKig
	 gxQsqcjVzK9v8uF8jsoyyu6dRKRoQJodDXi1CUz9VyHR2fCgDAbUMIt1Zaukn0ZZGq
	 lrepDo7svPF3kVpzSp7joPS6Epjrb3IHy1clsXkQ=
Date: Mon, 26 Feb 2024 09:06:22 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kfifo-fix-typos-in-kernel-doc.patch removed from -mm tree
Message-Id: <20240226170622.A858CC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfifo: fix typos in kernel-doc
has been removed from the -mm tree.  Its filename was
     kfifo-fix-typos-in-kernel-doc.patch

This patch was dropped because an updated version will be merged

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


