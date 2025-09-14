Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2814339FD9
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810098; cv=none; b=T56hjg2+FbtRHD1ZjkU3pqtJej6btfmWAsYClj91OyQD0RCeu2Gy1jem9eIVR8GxgOcUUESKN8thikDbCkL8ocv7P1HeZ+BTtq7QT5ZkuXaucnUTpV2X8qQ2VwWxfUt4/XtUxhr3PZr1L3rgWD44JL2kHOYuE/tsSTurX7CfsMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810098; c=relaxed/simple;
	bh=wCYoi+OUsiASz9+YK/1s3WjHs2SCBe2MtIxbeRPBRAA=;
	h=Date:To:From:Subject:Message-Id; b=Xs3QLZuBJF0pkbAbpzSk8eF3DHtElyIA9MvIYsFKc7AwdC20i+KButaLeDiVXjp3jPdPTgWvkrb1aPrOb4nmptShBKYaZSdUDt1/RBVzwVBcHkxIF8v3nnWg6QL6zJ5LIL2DPlcK9gpv3Ocosa9X3kSXUxIwVzkOvNUTcjN0OtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VC0SjEOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VC0SjEOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B53C4CEEB;
	Sun, 14 Sep 2025 00:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810098;
	bh=wCYoi+OUsiASz9+YK/1s3WjHs2SCBe2MtIxbeRPBRAA=;
	h=Date:To:From:Subject:From;
	b=VC0SjEOK8zxlSrltb7Brxcsc1/2ReEgak7W7uOrDp3o9HkqFiI0DQ7OM68yMf8jy0
	 nYP5JnTTt63I8o97hwa2EwTOhVNYZ6uzp/ZTykYv8Bixz52Z3QAqIfinamo0D61w0M
	 0a+sxV+YX/f8i0dvHEE2Mk4jdbwqhBiWA/XsIiFY=
Date: Sat, 13 Sep 2025 17:34:57 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,arnd@arndb.de,andreyknvl@gmail.com,soham.bagchi@utah.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-load-acquire-coverage-count-in-user-space-code.patch removed from -mm tree
Message-Id: <20250914003457.E7B53C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: load acquire coverage count in user-space code
has been removed from the -mm tree.  Its filename was
     kcov-load-acquire-coverage-count-in-user-space-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Soham Bagchi <soham.bagchi@utah.edu>
Subject: kcov: load acquire coverage count in user-space code
Date: Mon, 28 Jul 2025 12:43:18 -0600

Update the KCOV documentation to use a load-acquire operation for the
first element of the shared memory buffer between kernel-space and
user-space.

The load-acquire pairs with the write memory barrier used in
kcov_move_area().

[soham.bagchi@utah.edu: v2]
  Link: https://lkml.kernel.org/r/20250803180558.2967962-1-soham.bagchi@utah.edu
Link: https://lkml.kernel.org/r/20250728184318.1839137-2-soham.bagchi@utah.edu
Signed-off-by: Soham Bagchi <soham.bagchi@utah.edu>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/Documentation/dev-tools/kcov.rst~kcov-load-acquire-coverage-count-in-user-space-code
+++ a/Documentation/dev-tools/kcov.rst
@@ -361,7 +361,12 @@ local tasks spawned by the process and t
 	 */
 	sleep(2);
 
-	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
+        /*
+         * The load to the coverage count should be an acquire to pair with
+         * pair with the corresponding write memory barrier (smp_wmb()) on
+         * the kernel-side in kcov_move_area().
+         */
+	n = __atomic_load_n(&cover[0], __ATOMIC_ACQUIRE);
 	for (i = 0; i < n; i++)
 		printf("0x%lx\n", cover[i + 1]);
 	if (ioctl(fd, KCOV_DISABLE, 0))
_

Patches currently in -mm which might be from soham.bagchi@utah.edu are


