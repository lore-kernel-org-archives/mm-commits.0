Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1B11DE8BE
	for <mm-commits@vger.kernel.org>; Thu, 11 Dec 2025 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765487059; cv=none; b=S//lgGW+zmpNh8CKyTXcwzNlr/t+Cz+/jhv/UA5L7tLesdGBNz/zJFsayb7S5w+RBA1TZeSlFXI886nNkhijXYUqFGo+DekYU067sIbOlV61kjLmmEpibuLYJdbJcspWgUDX/ztj7sw1gG8MUpJfxghEqpiJy/vrGMrs1RbMJrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765487059; c=relaxed/simple;
	bh=kzXYMvi0ExOPW4Dmq8ATZd/H9BDymHBEAlhQu7HGNnY=;
	h=Date:To:From:Subject:Message-Id; b=hlHnDzHRQFq7cK+E7bSbClEW1lTOhZnQIrO7qU89jLXPfTHH72vTFXWXYAKOj0PS4pThvrHsImX9W/gZ2n+KUQiDP63mGx7WI4rN86o/pAYBD4IFCYq1Hi+pmUTYQlZ8HK/4Rc5BKizL8t5yannSpra0duxJkgf0a0CZpokOIt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1RZsjZOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1RZsjZOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC61EC4CEF7;
	Thu, 11 Dec 2025 21:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765487059;
	bh=kzXYMvi0ExOPW4Dmq8ATZd/H9BDymHBEAlhQu7HGNnY=;
	h=Date:To:From:Subject:From;
	b=1RZsjZOzRoElPjp62FcXGkODecowP0mv2eDVSJfkaxRxcr2vz2s4yN2eBAOsrPvI8
	 cYKKGecgKwA892i2vzHccZX0zR1dt4Eq+XdWsUcTRlw/11fDrm4tKkQ3Bnl+6Pu0+u
	 sSFGWA9p0OxbIW3Jkx6M0CshfeKMyEvjXvXXSiUg=
Date: Thu, 11 Dec 2025 13:04:18 -0800
To: mm-commits@vger.kernel.org,sln@onemain.com,martink@posteo.de,hverkuil@kernel.org,carlos.bilbao@kernel.org,wangyl5933@chinaunicom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-remove-one-of-the-entries-for-wangyuli.patch added to mm-nonmm-unstable branch
Message-Id: <20251211210418.EC61EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .mailmap: remove one of the entries for WangYuli
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-remove-one-of-the-entries-for-wangyuli.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-remove-one-of-the-entries-for-wangyuli.patch

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
From: WangYuli <wangyl5933@chinaunicom.cn>
Subject: .mailmap: remove one of the entries for WangYuli
Date: Mon, 8 Dec 2025 10:57:30 +0800

Since commit 01ef0296d2eb (".mailmap: add entry for WangYuli") was merged
into mainline, I've received feedback from former colleagues: They believe
the change to .mailmap affects git log based statistics, which in turn
reduces the reported “contributions from uniontech” in the Linux
commit tree, and they think it's difficult to explain to everyone that
future statistics must be generated with the --no-use-mailmap option.

I don't have a strong opinion either way, but since my commit has caused
them trouble, I'm now requesting that this line be removed to bring a
little more LOVE AND PEACE to the world :-)

Link: https://lkml.kernel.org/r/20251208025730.33881-1-wangyuli@aosc.io
Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Hans Verkuil <hverkuil@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 -
 1 file changed, 1 deletion(-)

--- a/.mailmap~mailmap-remove-one-of-the-entries-for-wangyuli
+++ a/.mailmap
@@ -849,7 +849,6 @@ Vladimir Davydov <vdavydov.dev@gmail.com
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
 WangYuli <wangyuli@aosc.io> <wangyl5933@chinaunicom.cn>
 WangYuli <wangyuli@aosc.io> <wangyuli@deepin.org>
-WangYuli <wangyuli@aosc.io> <wangyuli@uniontech.com>
 Weiwen Hu <huweiwen@linux.alibaba.com> <sehuww@mail.scut.edu.cn>
 WeiXiong Liao <gmpy.liaowx@gmail.com> <liaoweixiong@allwinnertech.com>
 Wen Gong <quic_wgong@quicinc.com> <wgong@codeaurora.org>
_

Patches currently in -mm which might be from wangyl5933@chinaunicom.cn are

mailmap-remove-one-of-the-entries-for-wangyuli.patch

