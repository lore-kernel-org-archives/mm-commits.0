Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7DA18C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628631; cv=none; b=ZWev1Cr53zXsSGNEVfKtXxwHKbell2yl8SPSepAUSyuEx2BQdeALCzT+54jxRwsrkrE8YKB/cZ0Lf07oedSDnA4EWeyBDQeQgQIitrn5UQOyq1p38RbMtO9MFcuhAZtr0fVPvk/FuwRKCrK19JRynpAXTyPsHfkY2UZnk1/iqB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628631; c=relaxed/simple;
	bh=j2RUDz8gNBcbLX8U93rT1RdJGQ4khF16gUdDcjngTHI=;
	h=Date:To:From:Subject:Message-Id; b=l0wBnNMewb/ZeXXmh41FqPShZtLVOq2tjVhWrrMkouuADklUX2rWVvJrw5sXSUgARi5obulKrHrGk7Z9yrfqKn39gXDgpLJxMj/KjR3r9J0Ia+dgeqkS5iyM8wWQkXMrfkPQKFr/q/rsQw+8iZnkfby+CKblRzGkRi76pZSl5IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MVCm090E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MVCm090E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C85C116B1;
	Sat, 29 Jun 2024 02:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628631;
	bh=j2RUDz8gNBcbLX8U93rT1RdJGQ4khF16gUdDcjngTHI=;
	h=Date:To:From:Subject:From;
	b=MVCm090EEmyNX0S1lxI10u2kunKMhRSPIzy8nUq4PLoAIFK4LzmqC2gsSqDoHRoxK
	 udRRvTN4WZQBX4mknWLYWBGpzn0HcyomBXNc2IZNsVOAfNTwtMNwaRb50NzxvfLY0y
	 /zgtrdgD2sQBjp5C4wCCJx21CQKSze8v4kGj6pms=
Date: Fri, 28 Jun 2024 19:37:10 -0700
To: mm-commits@vger.kernel.org,stefani@seibold.net,gregkh@linuxfoundation.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kfifo-add-missing-module_description-macros.patch removed from -mm tree
Message-Id: <20240629023711.30C85C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfifo: add missing MODULE_DESCRIPTION() macros
has been removed from the -mm tree.  Its filename was
     kfifo-add-missing-module_description-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: kfifo: add missing MODULE_DESCRIPTION() macros
Date: Sat, 1 Jun 2024 17:50:27 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kfifo/bytestream-example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kfifo/dma-example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kfifo/inttype-example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kfifo/record-example.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-samples-kfifo-v1-1-de34345c5fd8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/bytestream-example.c |    1 +
 samples/kfifo/dma-example.c        |    1 +
 samples/kfifo/inttype-example.c    |    1 +
 samples/kfifo/record-example.c     |    1 +
 4 files changed, 4 insertions(+)

--- a/samples/kfifo/bytestream-example.c~kfifo-add-missing-module_description-macros
+++ a/samples/kfifo/bytestream-example.c
@@ -191,5 +191,6 @@ static void __exit example_exit(void)
 
 module_init(example_init);
 module_exit(example_exit);
+MODULE_DESCRIPTION("Sample kfifo byte stream implementation");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
--- a/samples/kfifo/dma-example.c~kfifo-add-missing-module_description-macros
+++ a/samples/kfifo/dma-example.c
@@ -138,5 +138,6 @@ static void __exit example_exit(void)
 
 module_init(example_init);
 module_exit(example_exit);
+MODULE_DESCRIPTION("Sample fifo dma implementation");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
--- a/samples/kfifo/inttype-example.c~kfifo-add-missing-module_description-macros
+++ a/samples/kfifo/inttype-example.c
@@ -182,5 +182,6 @@ static void __exit example_exit(void)
 
 module_init(example_init);
 module_exit(example_exit);
+MODULE_DESCRIPTION("Sample kfifo int type implementation");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
--- a/samples/kfifo/record-example.c~kfifo-add-missing-module_description-macros
+++ a/samples/kfifo/record-example.c
@@ -198,5 +198,6 @@ static void __exit example_exit(void)
 
 module_init(example_init);
 module_exit(example_exit);
+MODULE_DESCRIPTION("Sample dynamic sized record fifo implementation");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are


