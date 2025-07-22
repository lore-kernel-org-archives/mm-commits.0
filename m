Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831E327A446
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220463; cv=none; b=AF+DWIcM2kl9gu9HNa1Aj5SxHJIRob5FsAdyo2FfMUhfz3q3fAhsBq2hodOhOaIXGJ9h/h5NfvcV6CED7EnUaDxWzu2uoBzKjuDTrFxrCI3/OB7UulXnubVhjPNkkrTsYqbPdDi9aAuFyX8uz1LM6Q1ucg9MBOIP0mdmsQPQkMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220463; c=relaxed/simple;
	bh=IlIMYX6G7BWqKOL/W/E4ObpOO0us7SFrZFPAXKPKhOc=;
	h=Date:To:From:Subject:Message-Id; b=miX4BCGuLX8YeHjtwu+Kgl+dIjAtVol1IZ12rjQJPq4GYK6d1sgoW0Jm35zqb6qaO1EADlVKq+c6jmwbl4XKnlX/zfbR6Rn6yyeAa2yxfkVajXxkQm0jrr5TFUmC7ucym4goOQ8gycixoQ9qfrDLghsjEk/SNps5M60oKt02/1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QoA+QtqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QoA+QtqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59051C4CEEB;
	Tue, 22 Jul 2025 21:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753220463;
	bh=IlIMYX6G7BWqKOL/W/E4ObpOO0us7SFrZFPAXKPKhOc=;
	h=Date:To:From:Subject:From;
	b=QoA+QtqP18O/kSLZtv5/FE43QsadkBQG7KA2Kz3XS+ZALJrK53m5oBsZMT3xHr3xh
	 qozPtxr6zr0l6la68iUT3BhiYrVfBA7F1/FjR8jSQDVMQJ0mDY2FFp+ZF7clQidWla
	 5V8VpoTBV2A3DzYz+ZDDp2lb8SfWL5bNM6Oi0Ev8=
Date: Tue, 22 Jul 2025 14:41:02 -0700
To: mm-commits@vger.kernel.org,jonathan.cameron@huawei.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch added to mm-nonmm-unstable branch
Message-Id: <20250722214103.59051C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/spelling.txt: add notifer||notifier to spelling.txt
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

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
From: WangYuli <wangyuli@uniontech.com>
Subject: scripts/spelling.txt: add notifer||notifier to spelling.txt
Date: Tue, 22 Jul 2025 15:34:31 +0800

This typo was not listed in scripts/spelling.txt, thus it was more
difficult to detect. Add it for convenience.

Link: https://lkml.kernel.org/r/02153C05ED7B49B7+20250722073431.21983-8-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-notifernotifier-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -1099,6 +1099,7 @@ notication||notification
 notications||notifications
 notifcations||notifications
 notifed||notified
+notifer||notifier
 notity||notify
 notfify||notify
 nubmer||number
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

kvm-x86-fix-typo-notifer.patch
cxl-mce-fix-typo-notifer.patch
drm-xe-fix-typo-notifer.patch
net-mvneta-fix-typo-notifer.patch
wifi-brcmfmac-fix-typo-notifer.patch
serial-8250_dw-fix-typo-notifer.patch
xen-xenbus-fix-typo-notifer.patch
scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

