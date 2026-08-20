Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D84382380
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 02:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787194543; cv=none; b=LKxXd6uyHs3KvZNkQnUgEYWgzPDyuDFD0KHax7T8MlJso9rXChQBOXzuRleh3FqsmrvIzShQhne51qHWSF7Q1P9WAgrobzDabDC1Rdu7d0fNVShqBK/12PdjKTSdspGt+Qp4yc0pp5v6fgvjCUxMur7kuxxXZHEDqNX4Y6H2hSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787194543; c=relaxed/simple;
	bh=WVF9lMJ7MZuS+AWqfbdQe2y2bhjZekkFcqN/djQg9L0=;
	h=Date:To:From:Subject:Message-Id; b=iLe0gaAOPK8anz1wW2/MR0z1WU6nm7fJuYHAEUl5R0tsjU7LhYvhLA3HSfV6URJ6pNZPCYOhJJCxI+7bRh5d1PHvDk8HM6Bt7TwnYmoMXvTYi/+Av0jRZ9ca56V4MAUEoN5IIskgIFVVKFvqePztq0MHCUd+mNac8VrCphml2IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2p/fx+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2p/fx+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DEF1F000E9;
	Thu, 20 Aug 2026 02:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787194541;
	bh=DyGCMqtt6nIlYuZ8LTXrUsloFFif2fMMd/ONwSF8cSU=;
	h=Date:To:From:Subject;
	b=x2p/fx+9xk+90my1WRrTrBUjAe7Dr6BJuRUM8uJpsnna1Ev2T44iUU8qdmsYhTYUv
	 u5/xy2kcLosVV7mPvikb6OVBFv1bp4mFy1fguNhrGxbw/1DCmDY4YNm4G8HZeIiWv5
	 Ghjfr03kigE1qsxbmGqt7XXKg6E95h+dHSH9VW1A=
Date: Wed, 19 Aug 2026 19:55:41 -0700
To: mm-commits@vger.kernel.org,taniya.das@oss.qualcomm.com,konrad.dybcio@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-fix-bouncing-address-for-taniya-das.patch removed from -mm tree
Message-Id: <20260820025541.A6DEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: fix bouncing address for Taniya Das
has been removed from the -mm tree.  Its filename was
     mailmap-fix-bouncing-address-for-taniya-das.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: mailmap: fix bouncing address for Taniya Das
Date: Mon, 17 Aug 2026 15:33:46 +0200

The quic_username@quicinc.com emails have been deprecated inside Qualcomm
for a while now in favor of firstname.lastname@oss.qualcomm.com Re-route
the emails to Taniya's current OSS email address to avoid Outlook bounces
("recipient's inbox is full").

Link: https://lore.kernel.org/20260817-topic-taniya_email_bounce-v1-1-d7af1f113d64@oss.qualcomm.com
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Taniya Das <taniya.das@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-fix-bouncing-address-for-taniya-das
+++ a/.mailmap
@@ -864,7 +864,8 @@ Szymon Wilczek <swilczek.lx@gmail.com> <
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

Patches currently in -mm which might be from konrad.dybcio@oss.qualcomm.com are


