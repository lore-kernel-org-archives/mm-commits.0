Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=5.75.144.95
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811576;
	b=oaMiL/Yp/ybP3ug29g6llVIDmqkpfzxSViF4CuyV57VhUV2Fq4XjCMB6ZNiLE2WOhCyY
	 f9Y169xEEmh0MfMFIOUPG/0TzdI2NpZGt12n3NxKwScTS4mFKlxqZlE89IYkLyQaq7S9H
	 q3ElguM3l1UlBkz5TnPelA/5nBmxFDM+p2kUbVne8jH/EUunap4VpdVqRZ39+/OYPD3cN
	 LCCVAxoX6WWBXJBNOMDOVNcdlw2pxxm9+9r1Vtv/NrFjn/1EN67tXcO355iKbrMQbcRyX
	 sMYT+vJnfSL0YUZH5Tu1vsIiNtdrxnpm8834GMNUPdGr0tP2a1zfxYOjZemEWHt8xlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811576;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Date:From:To:Subject:
	 In-Reply-To:References:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=XfhgKVtQ5dojD2Q8McU4YF8BrwoEl1gSe+F28eZNskM=;
	b=L4hKoN32oBQMfegHOGCkGLzo1kmYq5hXOoRTCY0xW3CBV3IdmbFGYOpGR4uSlnv60REK
	 dwPD/RltFIe7oPXh7hnJMs5HO9477V50v5oyzEz74YgrpRq8pgRE3DU/s4cZIR5sf9uly
	 JyYgFeN+DbGT0EdqouDjo+UndFC88iUg6AS6ltka60acJy+zNY2PEEjp8gzdLlzbnlWg3
	 qC27jTnfkKBr2oianVL20s62jfZyN+gps8D0t59c4A0hFuH2kmHmmO35oKn6N/5pxSvpK
	 JfkpY3QnYyqsMzBx5r75TKL/GfYUKtOjZ4HOmrM7WOXR3sQEN/nSBOy+FcihC4LT1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mainlining.org;
	spf=pass smtp.mailfrom=mainlining.org;
	dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=rsa-sha256 header.s=202507r header.b=rN3pE56g;
	dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=ed25519-sha256 header.s=202507e header.b=mcoMo0nt;
	arc=none smtp.remote-ip=5.75.144.95
Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3542D606D816
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 16:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3542D606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mainlining.org header.i=@mainlining.org header.a=rsa-sha256 header.s=202507r header.b=rN3pE56g;
	dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=ed25519-sha256 header.s=202507e header.b=mcoMo0nt
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1793811555; bh=XfhgKVtQ5dojD2Q8McU4YF8
	BrwoEl1gSe+F28eZNskM=; b=rN3pE56gp0ub/wOt5ATgMkf3tLYJk0QqDUKm12trg1DzVOvg7b
	v3krBnUSyXMSC2DrqmaHFUg4LbZqLRYjYonL+Msbr06MPZY1OAPadaV+R89mnBGPcoT/GkaIXqs
	KQmFh6DZugMQCrgoykfOiiqw6r0EYAQk79MJZPfU+eXK2hEUbDHv+gZ8UnZqtgP0Q8ty0JgJHQv
	QXpKGtsPowdqNxkMgnpsiFrjD9P0QwYOLTtf18eQ+QGsZvoE0g7MdsqNzU+pzH/qpb/4Bnqys8Y
	fcHcQ66ClZ1VjfoyincMwaS3H4DId0xcTYRqfec1jtHln2nM3coPVB3+9XvjlZ7610g==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1793811555; bh=XfhgKVtQ5dojD2Q8McU4YF8
	BrwoEl1gSe+F28eZNskM=; b=mcoMo0ntDuv3Q5a0SaH8Mf8+uUpomq2aljfYKmE/KpOxYnZ69T
	sNuA661YueD4KHiN2UsRLLMMgrvppwQ2/gBQ==;
Date: Wed, 04 Nov 2026 16:59:13 +0000
From: Bradley Morgan <brads@mainlining.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 yang_yongxin123@163.com, akpm@linux-foundation.org, yangyongxin@kylinos.cn
Subject: =?US-ASCII?Q?Re=3A_+_perf-profile-report-failure-to-create-proc?=
 =?US-ASCII?Q?-profile=2Epatch_added_to_mm-nonmm-unstable_branch?=
In-Reply-To: <20261104165807.7E1BB1F00A16@smtp.kernel.org>
References: <20261104165807.7E1BB1F00A16@smtp.kernel.org>
Message-ID: <85683B62-43A3-4635-983B-509E9AFCE0BA@mainlining.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 4 November 2026 16:58:06 GMT, Andrew Morton <akpm@linux-foundation.org>
wrote:
>
>The patch titled
>     Subject: perf/profile: report failure to create /proc/profile
>has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>     perf-profile-report-failure-to-create-proc-profile.patch
>
>This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-profile-report-failure-to-create-proc-profile.patch
>
>This patch will later appear in the mm-nonmm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when
>testing your code ***
>
>The -mm tree is included into linux-next via various
>branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>and is updated there most days
>
>------------------------------------------------------
>From: Yongxin Yang <yangyongxin@kylinos.cn>
>Subject: perf/profile: report failure to create /proc/profile
>Date: Wed,  4 Nov 2026 17:32:58 +0800
>
>create_proc_profile() discards the result of proc_create(): when the entry
>cannot be created, the function still returns 0 and profiling setup
>silently pretends to have succeeded.  The local variable err is never
>assigned anything but 0 and only hides that.
>
>Report the failure and return -ENOMEM instead.
>
>create_proc_profile() is a subsys_initcall and do_initcall_level()
>discards the initcall return value, so the error message is what the user
>will actually see.
>
>Link: https://lore.kernel.org/20261104093258.1802802-1-yangyongxin@kylinos.cn
>Signed-off-by: Yongxin Yang <yangyongxin@kylinos.cn>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
>Cc: Bradley Morgan <brads@mainlining.org>

Thx for CCing me:

Reviewed-by: Bradley Morgan <brads@mainlining.org>

>Cc: <yang_yongxin123@163.com>
>---
>
> kernel/profile.c |   10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-)
>
>--- a/kernel/profile.c~perf-profile-report-failure-to-create-proc-profile
>+++ a/kernel/profile.c
>@@ -240,15 +240,17 @@ static const struct proc_ops profile_pro
> int __ref create_proc_profile(void)
> {
> 	struct proc_dir_entry *entry;
>-	int err = 0;
> 
> 	if (!prof_on)
> 		return 0;
> 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
> 			    NULL, &profile_proc_ops);
>-	if (entry)
>-		proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
>-	return err;
>+	if (!entry) {
>+		pr_err("profile: failed to create /proc/profile\n");
>+		return -ENOMEM;
>+	}
>+	proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
>+	return 0;
> }
> subsys_initcall(create_proc_profile);
> #endif /* CONFIG_PROC_FS */
>_
>
>Patches currently in -mm which might be from yangyongxin@kylinos.cn are
>
>perf-profile-report-failure-to-create-proc-profile.patch
>


--- Thanks!
https://lore.kernel.org/all/EE579805-42F2-4C58-B752-F28779EEB717@grrlz.net/
