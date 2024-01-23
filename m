Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564B05BAC5
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970540; cv=none; b=pM83sAYc6FvbtBO/g5EZSPFQroR0NjYJ8rhNOXFlS399Kzhdu0C4K2ch9eugO1jemJaFdmq1d0r4TddiqcwECQH34gNXuf5YiIf/PwfaQWiU61orIHEwkfQM93C4OW0D85xGmlFi1qxj1VjXUc1E5OWBizt5lAS/ogg4QuRMfKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970540; c=relaxed/simple;
	bh=OV3JS5ox/Qve7aSoLxIzkrl3zKxX97ou3bGX2L/HvUU=;
	h=Date:To:From:Subject:Message-Id; b=icW7Hth3yGXuGcsmNNgRxCfHicE9s+OgrZYtJPUgYYdNCq+w2BgquuBcjorxHYBWzlK1kt1bv+kjwZ3UmCrWUP9/9tU0/+MlFlpr7Nsj0svg+ITWvghbyo77i7/GhW8KGZqAo1Go6mNSRVS/T2QECLa7tNqI+M5jEpmVAn8+DoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KZ6Pobn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KZ6Pobn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07B6C433F1;
	Tue, 23 Jan 2024 00:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970540;
	bh=OV3JS5ox/Qve7aSoLxIzkrl3zKxX97ou3bGX2L/HvUU=;
	h=Date:To:From:Subject:From;
	b=KZ6Pobn5S1+22d6olRVTjc3JwjK+hfD2fgrvr3V6S4TkEr/EilfRaYP72mMoju08q
	 Qc92fE1EUoS4I5XiXmt0imKIIK893oe4GrlToQalrp0IU+8DEVqwwrXBJxwfXYT0ig
	 GCSSqpryW4l1f6ZgkDNzXFlldCmRp5a3sIKMkMFU=
Date: Mon, 22 Jan 2024 16:42:17 -0800
To: mm-commits@vger.kernel.org,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-dhry-use-ktime_ms_delta-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004219.B07B6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: dhry: use ktime_ms_delta() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-dhry-use-ktime_ms_delta-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-dhry-use-ktime_ms_delta-helper.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib: dhry: use ktime_ms_delta() helper
Date: Mon, 22 Jan 2024 15:50:44 +0100

Use the existing ktime_ms_delta() helper instead of open-coding the same
operation.

Link: https://lkml.kernel.org/r/bb43c67a7580de6152f5e6eb225071166d33b6e4.1705934853.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dhry_1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/dhry_1.c~lib-dhry-use-ktime_ms_delta-helper
+++ a/lib/dhry_1.c
@@ -277,7 +277,7 @@ int dhry(int n)
 	dhry_assert_string_eq(Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
 	dhry_assert_string_eq(Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
 
-	User_Time = ktime_to_ms(ktime_sub(End_Time, Begin_Time));
+	User_Time = ktime_ms_delta(End_Time, Begin_Time);
 
 	kfree(Ptr_Glob);
 	kfree(Next_Ptr_Glob);
_

Patches currently in -mm which might be from geert+renesas@glider.be are

lib-dhry-remove-unneeded-linux-mutexh.patch
lib-dhry-use-ktime_ms_delta-helper.patch
lib-dhry-add-missing-closing-parenthesis.patch

