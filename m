Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F077C181
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717200385; cv=none; b=gauIcTEI4CXBNWRm/60peFQu5S/D4td6MR8YQrSH8ocdOISWBGAVIMuNusuBsYBeRFgJ2PB+c9sN6V8ScrGLFE9IOnBBlqpKq4bKEGqDe3j2gs/bhY4AeBfNXLcHd/hpotLLcK3+rdgURoL5f04T+L8tR8CuoTlTEr2lRySNJWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717200385; c=relaxed/simple;
	bh=q+l7AcLifLQf2CjYlCD4ikgTYUS+0cwYJCr+RMHud/o=;
	h=Date:To:From:Subject:Message-Id; b=ptyl4pYwVeOhhV3BYaTws+RihjfL7spQQCvEe7srungdVYsuRngRDj9sLFQfKMNSCsTBXC+4OSwCme7U6CCe6GrzA+yxP4TJvuGXNAQbWEgr+t1xfOgPEEmD8qzvnjEpDTI8rTdFdHYiwg2PUPEd3jOzUATOTdGwxpgbWDzDOQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/IMkAhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/IMkAhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550EBC116B1;
	Sat,  1 Jun 2024 00:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717200384;
	bh=q+l7AcLifLQf2CjYlCD4ikgTYUS+0cwYJCr+RMHud/o=;
	h=Date:To:From:Subject:From;
	b=x/IMkAhR0GiqkfYB7WQrXDt/pnId2YZg87MPT1QkA33c1PzIgYXhOFcazwH2uC7dk
	 DUY+f8X+OHCmq1aR4jrlxsBNy18e9RH3ceTg18RUZh6w8W318FrVDMahjPg40fw8ZL
	 f2tPUIn5PI4ZSOre5ddIk1Gb41jOHLg4QxB8iqeQ=
Date: Fri, 31 May 2024 17:06:23 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-panic-return-early-from-print_tainted-when-not-tainted.patch added to mm-nonmm-unstable branch
Message-Id: <20240601000624.550EBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/panic: return early from print_tainted() when not tainted
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-panic-return-early-from-print_tainted-when-not-tainted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-panic-return-early-from-print_tainted-when-not-tainted.patch

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
From: Jani Nikula <jani.nikula@intel.com>
Subject: kernel/panic: return early from print_tainted() when not tainted
Date: Fri, 31 May 2024 12:04:54 +0300

Reduce indent to make follow-up changes slightly easier on the eyes.

Link: https://lkml.kernel.org/r/01d6c03de1c9d1b52b59c652a3704a0a9886ed63.1717146197.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/kernel/panic.c~kernel-panic-return-early-from-print_tainted-when-not-tainted
+++ a/kernel/panic.c
@@ -507,22 +507,23 @@ const struct taint_flag taint_flags[TAIN
 const char *print_tainted(void)
 {
 	static char buf[TAINT_FLAGS_COUNT + sizeof("Tainted: ")];
+	char *s;
+	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
 
-	if (tainted_mask) {
-		char *s;
-		int i;
-
-		s = buf + sprintf(buf, "Tainted: ");
-		for (i = 0; i < TAINT_FLAGS_COUNT; i++) {
-			const struct taint_flag *t = &taint_flags[i];
-			*s++ = test_bit(i, &tainted_mask) ?
-					t->c_true : t->c_false;
-		}
-		*s = 0;
-	} else
+	if (!tainted_mask) {
 		snprintf(buf, sizeof(buf), "Not tainted");
+		return buf;
+	}
+
+	s = buf + sprintf(buf, "Tainted: ");
+	for (i = 0; i < TAINT_FLAGS_COUNT; i++) {
+		const struct taint_flag *t = &taint_flags[i];
+		*s++ = test_bit(i, &tainted_mask) ?
+			t->c_true : t->c_false;
+	}
+	*s = 0;
 
 	return buf;
 }
_

Patches currently in -mm which might be from jani.nikula@intel.com are

kernel-panic-return-early-from-print_tainted-when-not-tainted.patch
kernel-panic-convert-print_tainted-to-use-struct-seq_buf-internally.patch
kernel-panic-initialize-taint_flags-using-a-macro.patch
kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces.patch

