Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21984472550
	for <mm-commits@vger.kernel.org>; Mon, 17 Aug 2026 21:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787002973; cv=none; b=M1hjDt3YPDn4AcpzwVKjn9F8cyocFYr1P0CvjyneAND7PbvmJiE8sBL+BuawRwnGK3GxMk+z0sxokJFQ6Jx0xyX0STQKO1d7R2S7ikwRK2uOY+3Dg7S9njjzQLsDHrMXqEWIzdKU1ehWmAkdc9ySSzDYnOxtMU7RFCx7VlXkXJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787002973; c=relaxed/simple;
	bh=l2UqfTM5f5ydiYDNfFxwi18R5OIQULljBB/UCmJQCeg=;
	h=Date:To:From:Subject:Message-Id; b=VHKWTduUne5vFz3A+DMBfZJX7FSIxADK9J+y4aplxjBZMAMlYM4mp7/iD6hkMvVNu/mv27FTjUYO2I+jJGuDcfAMLT6URJvcjj7kYt2A+uV3xX2qQKLhCtlTrsnQSdpNPw3td2UjQduJ+dnCBwp4i/WHt4fUsfCGF+zLuesdH5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vCtVW6ws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vCtVW6ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912061F000E9;
	Mon, 17 Aug 2026 21:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787002971;
	bh=imycEkTRcTcaCd3bnGa3HgFVI/FjaOSJZk6htCXg21k=;
	h=Date:To:From:Subject;
	b=vCtVW6wsIykyCVggwQ3Esy9kXP3TnK7Rz8jyVdRe7N2AM7DXxI6CGjH/evIx4ZEmB
	 RGDWFVF7gPDjCEmqYik0GXIjVgDP2PcArE2B13AQ2OuZecVFzRdOVSd8PgjrnpqK+w
	 QiViokzuRd3UOUx62aFzlhrqhU5TutIkboBGftSE=
Date: Mon, 17 Aug 2026 14:42:51 -0700
To: mm-commits@vger.kernel.org,taniya.das@oss.qualcomm.com,konrad.dybcio@oss.qualcomm.com,konradybcio@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-fix-bouncing-address-for-taniya-das.patch added to mm-nonmm-unstable branch
Message-Id: <20260817214251.912061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: Fix bouncing address for Taniya Das
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-fix-bouncing-address-for-taniya-das.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-fix-bouncing-address-for-taniya-das.patch

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
From: Konrad Dybcio <konradybcio@kernel.org>
Subject: mailmap: Fix bouncing address for Taniya Das
Date: Mon, 17 Aug 2026 15:33:46 +0200


The quic_username@quicinc.com emails have been deprecated inside
Qualcomm for a while now in favor of firstname.lastname@oss.qualcomm.com
Re-route the emails to Taniya's current OSS email address to avoid
Outlook bounces ("recipient's inbox is full").

Link: https://lore.kernel.org/20260817-topic-taniya_email_bounce-v1-1-d7af1f113d64@oss.qualcomm.com
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Taniya Das <taniya.das@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-fix-bouncing-address-for-taniya-das
+++ a/.mailmap
@@ -873,7 +873,8 @@ Szymon Wilczek <swilczek.lx@gmail.com> <
 Takashi YOSHII <takashi.yoshii.zj@renesas.com>
 Tamir Duberstein <tamird@kernel.org> <tamird@gmail.com>
 Tamizh Chelvam Raja <quic_tamizhr@quicinc.com> <tamizhr@codeaurora.org>
-Taniya Das <quic_tdas@quicinc.com> <tdas@codeaurora.org>
+Taniya Das <taniya.das@oss.qualcomm.com> <quic_tdas@quicinc.com>
+Taniya Das <taniya.das@oss.qualcomm.com> <tdas@codeaurora.org>
 Tanzir Hasan <tanzhasanwork@gmail.com> <tanzirh@google.com>
 Tejun Heo <htejun@gmail.com>
 Tomeu Vizoso <tomeu@tomeuvizoso.net> <tomeu.vizoso@collabora.com>
_

Patches currently in -mm which might be from konradybcio@kernel.org are

mailmap-fix-bouncing-address-for-taniya-das.patch

