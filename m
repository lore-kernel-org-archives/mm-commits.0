Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A6D14A4F0
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 23:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724197251; cv=none; b=cmMYWBfJPI+wqYo+l9XrOQWpmLEjmnUi3IWYjbZ5Q/xQsjbd8JPtkhvd5pk+AT9RxzP1FAFy3lxzEdyoUwcgl0WPmZGBzGDFv1WsBmB6q4kWv9KURB/koGpSSesU8pheB9k3E0ssIh55VC5OxW7diXUsw2syWAAnJcBYqoSVL78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724197251; c=relaxed/simple;
	bh=oEGNC+iK3lyMHo98Cp3ZS/taY9BtsjOe2AG+qv236eE=;
	h=Date:To:From:Subject:Message-Id; b=KqjhEwPiALVx2szuNuTH++Dyirb5aA/zhDXWseceZdDHOX2iFKcmgY3hkc61DV6Um+/F5mBznK8zUzbkm3QbUZlOWRl/wnKQJ5uW6IHk28k84iLpaRjKdHlWVEvZkPsCT39SCpffNFX9Tsqy6j3sWuFVQza9976PatxOE/yHoGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RPilq47Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RPilq47Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5E2C4AF49;
	Tue, 20 Aug 2024 23:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724197250;
	bh=oEGNC+iK3lyMHo98Cp3ZS/taY9BtsjOe2AG+qv236eE=;
	h=Date:To:From:Subject:From;
	b=RPilq47YdisO3kXPrWkjnkh15bH8SgF/7M1rAUv9m/3HvF1rCOQJNE6lBC9O9BWjj
	 HXfqhfGuSWHHxpqu+QLlnYKaMFgMDLo/YK7/HyytiDmYXpoEPlbKg2RMc6/VogiKdx
	 AHvaGuwtSKZFwnTlVszCsqBI9VG4S85G7D9mpxDc=
Date: Tue, 20 Aug 2024 16:40:50 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-max-to-improve-ocfs2_dlm_seq_show.patch added to mm-nonmm-unstable branch
Message-Id: <20240820234050.CA5E2C4AF49@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use max() to improve ocfs2_dlm_seq_show()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-max-to-improve-ocfs2_dlm_seq_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-max-to-improve-ocfs2_dlm_seq_show.patch

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
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: ocfs2: use max() to improve ocfs2_dlm_seq_show()
Date: Tue, 20 Aug 2024 04:16:07 +0200

Use the max() macro to simplify the ocfs2_dlm_seq_show() function and
improve its readability.

Link: https://lkml.kernel.org/r/20240820021605.97887-3-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-use-max-to-improve-ocfs2_dlm_seq_show
+++ a/fs/ocfs2/dlmglue.c
@@ -3151,11 +3151,8 @@ static int ocfs2_dlm_seq_show(struct seq
 #ifdef CONFIG_OCFS2_FS_STATS
 	if (!lockres->l_lock_wait && dlm_debug->d_filter_secs) {
 		now = ktime_to_us(ktime_get_real());
-		if (lockres->l_lock_prmode.ls_last >
-		    lockres->l_lock_exmode.ls_last)
-			last = lockres->l_lock_prmode.ls_last;
-		else
-			last = lockres->l_lock_exmode.ls_last;
+		last = max(lockres->l_lock_prmode.ls_last,
+			   lockres->l_lock_exmode.ls_last);
 		/*
 		 * Use d_filter_secs field to filter lock resources dump,
 		 * the default d_filter_secs(0) value filters nothing,
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

lib-test_hmm-use-min-to-improve-dmirror_exclusive.patch
lib-checksum-use-array_size-to-improve-assert_setup_correct.patch
ocfs2-use-max-to-improve-ocfs2_dlm_seq_show.patch

