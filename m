Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949921E8854
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 21:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744406314; cv=none; b=gNLckP0m5uec/InGu+3sjsboD1owVxQ3IzdcGVEyTO3lZB/MKSihtyJTtom1vv3T/N/WcGF5KEd1d3pBrUtT+P62CgfKWpLneAC4w/865OHhB3uMR0C2Y3lxlK+rNxcnTjQgFzIW1bAv2AsnXX78MjckcLV1uvfGSh3AML+Jp8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744406314; c=relaxed/simple;
	bh=5mjjvAnVfFJmFqxxycR7PA93BGrh9tvhUeHmIV1qxLg=;
	h=Date:To:From:Subject:Message-Id; b=UOOH9fZ2CNn0LywF7sIf9u/3MCVHBQXWac3aJIb3CFs9LHhmlisVzQEPqhv/58W1Io06Ea6mxhsjzCNS+rj4XLvXlES70e5tKU9A6DWNyyPKmun7icodvYjmtcyjZEDu9HXOTz+FqkkEoW40SYTzSvgZABfu0ghlTVDscXcpJDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bp0+dedU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bp0+dedU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DD1C4CEE2;
	Fri, 11 Apr 2025 21:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744406314;
	bh=5mjjvAnVfFJmFqxxycR7PA93BGrh9tvhUeHmIV1qxLg=;
	h=Date:To:From:Subject:From;
	b=Bp0+dedUpG8wlutSDq4uHUpRGWbEf/Sla3Zm1fS5LKdNaB092B8+fHqBha9oBmi+c
	 SXje25D9XQApmiBz1HGKRGbvyK5JGv+RkBoCcjU/TBugxHgnuHjQX6+nGYX1ZeuM8S
	 dj8LWGJCaSgk6Auk7ecyC/+oG0+wKMXR2s32YicE=
Date: Fri, 11 Apr 2025 14:18:33 -0700
To: mm-commits@vger.kernel.org,macro@orcam.me.uk,ldv@strace.io,deller@gmx.de,charlie@rivosinc.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] syscallh-add-syscall_set_arguments-fix-fix.patch removed from -mm tree
Message-Id: <20250411211833.E3DD1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: syscallh-add-syscall_set_arguments-fix-fix
has been removed from the -mm tree.  Its filename was
     syscallh-add-syscall_set_arguments-fix-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: syscallh-add-syscall_set_arguments-fix-fix
Date: Tue, 8 Apr 2025 17:38:03 -0700

fix syscall_get_arguments() also

Link: https://lkml.kernel.org/r/20250409003803.GA2876360@ax162
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Helge Deller <deller@gmx.de> # parisc
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: "Dmitry V. Levin" <ldv@strace.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/syscall.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/syscall.h~syscallh-add-syscall_set_arguments-fix-fix
+++ a/arch/riscv/include/asm/syscall.h
@@ -62,8 +62,11 @@ static inline void syscall_get_arguments
 					 unsigned long *args)
 {
 	args[0] = regs->orig_a0;
-	args++;
-	memcpy(args, &regs->a1, 5 * sizeof(args[0]));
+	args[1] = regs->a1;
+	args[2] = regs->a2;
+	args[3] = regs->a3;
+	args[4] = regs->a4;
+	args[5] = regs->a5;
 }
 
 static inline void syscall_set_arguments(struct task_struct *task,
_

Patches currently in -mm which might be from nathan@kernel.org are

syscallh-add-syscall_set_arguments-fix.patch

