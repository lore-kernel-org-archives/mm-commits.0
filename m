Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811488;
	b=zYwFRwn3MpNhaKMEyDoIbGT/XOMia2yejL1caT1wh/p22oxWuFuaRuxnDl4Aya3brOs7
	 FjOtiw24/DewDpoIMKz6kzEL0nBYemgP5SbI/1CEboCf3VsvUoK5/EIacuG74BiOxybcs
	 fFdt1QuCEgjJfV22ELpqzk3RgmbB8h7OTxzeANMmRURMI3XPtqf1OX7YBO3AYVQr/Xa/X
	 Pnj6P+5qqcMrrSBmbXmuS0mkg58xspf4pEUi84OKQFnKsCGgx/hq6dn9smq/MPFCOWCl8
	 V6x4AFQnviTw2ags1o+QZ3XfdLKXAgR5X2T+kIOmy/cKMfC/o5wt8nnraxs5/JePI1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811488;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2ER22gq5gjrkHZ60/wmCQUykjT5MBSq/DqMHt9ypxEI=;
	b=v8EUt16eZmTGHVx0tcvlhtZ2pbvEQBonuPdzpeuUeOyyzk+k3NqpO6rrUY448EZClOhe
	 E/zqzzmJl+nhg+lCbFq78PFGpUvobg4g35N9IGC8kL9cWHdP6VnDnnspCAlXj2fHnhAoy
	 TFOLyUW2azmczVjtYh/lz1c5z0gyV3aSaaBF/mVJSWE00CMqmOCe58Yb/v+2z+rmIwrtI
	 NhCmqdNyQ7lmcTA1br1qR6JB6Zl3e1LGz+IAZeMBoCOBgvlVLQrU1zy1nEEChwWZGnG6E
	 uxz1kNyUt1fD0tcPvKJUdN+8g8T/HkKTmBWY4tjlXhR6zyl7A0M60rikuxvCY+k3OSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=h96jO9EO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C21606D83F
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 16:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=h96jO9EO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1BB1F00A16;
	Wed,  4 Nov 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793811487;
	bh=2ER22gq5gjrkHZ60/wmCQUykjT5MBSq/DqMHt9ypxEI=;
	h=Date:To:From:Subject;
	b=h96jO9EOyE0M6Hd5Sj6s69+IQ91wOVl61hYKgJLrm4W0WTmQueBB0RPW7c0TsmBy4
	 bm7CETkqLlL6C9ROtrZuFV8hxbvdjE3lUV6oVQgacMjvgdbYTdW1S/9gf9nPnCPuSk
	 unSvDGucseyKBYEO/TnyiG1ZZ/CnaRp/NlToeUxY=
Date: Wed, 04 Nov 2026 08:58:06 -0800
To: mm-commits@vger.kernel.org,yang_yongxin123@163.com,brads@mainlining.org,
	akpm@linux-foundation.org,yangyongxin@kylinos.cn
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-profile-report-failure-to-create-proc-profile.patch added to mm-nonmm-unstable branch
Message-Id: <20261104165807.7E1BB1F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: perf/profile: report failure to create /proc/profile
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     perf-profile-report-failure-to-create-proc-profile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-profile-report-failure-to-create-proc-profile.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yongxin Yang <yangyongxin@kylinos.cn>
Subject: perf/profile: report failure to create /proc/profile
Date: Wed,  4 Nov 2026 17:32:58 +0800

create_proc_profile() discards the result of proc_create(): when the entry
cannot be created, the function still returns 0 and profiling setup
silently pretends to have succeeded.  The local variable err is never
assigned anything but 0 and only hides that.

Report the failure and return -ENOMEM instead.

create_proc_profile() is a subsys_initcall and do_initcall_level()
discards the initcall return value, so the error message is what the user
will actually see.

Link: https://lore.kernel.org/20261104093258.1802802-1-yangyongxin@kylinos.cn
Signed-off-by: Yongxin Yang <yangyongxin@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Bradley Morgan <brads@mainlining.org>
Cc: <yang_yongxin123@163.com>
---

 kernel/profile.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/profile.c~perf-profile-report-failure-to-create-proc-profile
+++ a/kernel/profile.c
@@ -240,15 +240,17 @@ static const struct proc_ops profile_pro
 int __ref create_proc_profile(void)
 {
 	struct proc_dir_entry *entry;
-	int err = 0;
 
 	if (!prof_on)
 		return 0;
 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
 			    NULL, &profile_proc_ops);
-	if (entry)
-		proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
-	return err;
+	if (!entry) {
+		pr_err("profile: failed to create /proc/profile\n");
+		return -ENOMEM;
+	}
+	proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
+	return 0;
 }
 subsys_initcall(create_proc_profile);
 #endif /* CONFIG_PROC_FS */
_

Patches currently in -mm which might be from yangyongxin@kylinos.cn are

perf-profile-report-failure-to-create-proc-profile.patch

