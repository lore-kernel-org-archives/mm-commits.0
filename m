Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793562276;
	b=h/d3DJJ9a7BtHEjdUeYKBHT34LBqYv/y1CHWjrgAqFVNeFtIig5F/8ICsSkE1KXBipKb
	 1l11NYbXmSe55xF8dKOxAWF+mPF23ELokG28V9x1zAOqEG+shc+MxkTSNNuWRHjFSgWC3
	 UauzlxsQSpCYDARY12q5V11G/J0dStbVCvhTO2t65zJmMtcfoy0NIbNoZgcQKwCszQU61
	 J8GtkISXEw479Y7erUI2yAbucVZFc3cwhWaxLeYSWZiGYTImhwcx79q9T3tKozthbPSlY
	 iF6NaEJHSeozD69OvMWXIRtYEB9URWg8ITaQPOeeeMS0LC7tWHEZ1KwpvcBETEF5p3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562276;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rmho93q5k5CGNQGrj7mwLl44PkdMtkDSQUVhTi2u6B0=;
	b=VqakwIG+yHLLVlH8CiRlo9T44s6gmrYP0HrcEi+4YrTg/FLNELgHCHDwJtxHekPaRaXc
	 /JRCaK15MG2VA/9cwmag31PIBa+20uXhKUr1y4yx08Jy3jA81PoenYJHXMq9WVQwnUP3g
	 sR67BXW46FRmpoL0qJCGeWNQcd4WuMpWNCm7+JvnHhcSTce2k3LGAR8XAGrFbmJtXxn2g
	 vO+Wjcu6Km+zbiEyDG0KYxSBE7Zfr7O5+LDxxFXb0vXAsSM23neKOHzFPeEqkgGXR59HR
	 eA8YqhrxLnt+dS77dJXc+CbYFbLOEUse+a4PCYxMlcyxKyPgIfmidGK/POHDpW13fjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=z4jR1KPD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4FE606A330
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 19:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=z4jR1KPD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199341F000C1;
	Sun,  1 Nov 2026 19:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793562276;
	bh=rmho93q5k5CGNQGrj7mwLl44PkdMtkDSQUVhTi2u6B0=;
	h=Date:To:From:Subject;
	b=z4jR1KPDFTDNSiQRTgQJoo2uNH7gvEiX3RIO73AL39No+6PUulSPFWuLnXN1yqT3+
	 gFKzx+ywisurp9dSe2ir83P6kgs7LMrRnGepMqdXZnuFCF4KCc7DMJ6GuIRgmCqw7W
	 qlK6yt/a4YExzZitlL7CXuAwKJzLl1CIJwc1snBo=
Date: Sun, 01 Nov 2026 11:44:35 -0800
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,brads@mainlining.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task.patch added to mm-nonmm-unstable branch
Message-Id: <20261101194436.199341F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: taskstats: use div_u64() for the elapsed time in tgid_stats_add_task()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task.patch

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
From: Bradley Morgan <brads@mainlining.org>
Subject: taskstats: use div_u64() for the elapsed time in tgid_stats_add_task()
Date: Sun, 01 Nov 2026 00:57:43 +0000

tgid_stats_add_task() converts utime and stime with div_u64() and the
elapsed time with do_div(), two ways of doing the same 64-bit divide four
lines apart.  do_div() clobbers its first argument, which is the only
reason delta needs a statement of its own.  Both end up at a native
divide on 64-bit and at __div64_32() on 32-bit, so this is only about
picking one.

Link: https://lore.kernel.org/20261101005743.3022780-4-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>
---

 kernel/taskstats.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/taskstats.c~taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task
+++ a/kernel/taskstats.c
@@ -226,8 +226,7 @@ static void tgid_stats_add_task(struct t
 	/* calculate task elapsed time in nsec */
 	delta = now_ns - tsk->start_time;
 	/* Convert to micro seconds */
-	do_div(delta, NSEC_PER_USEC);
-	stats->ac_etime += delta;
+	stats->ac_etime += div_u64(delta, NSEC_PER_USEC);
 
 	task_cputime(tsk, &utime, &stime);
 	stats->ac_utime += div_u64(utime, NSEC_PER_USEC);
_

Patches currently in -mm which might be from brads@mainlining.org are

taskstats-use-nla_put_u32-in-mk_reply.patch
taskstats-take-the-inode-once-in-exe_add_tsk.patch
taskstats-reuse-na-in-cgroupstats_user_cmd.patch
taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task.patch

