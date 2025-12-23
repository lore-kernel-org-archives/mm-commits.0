Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9B02690F9
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517851; cv=none; b=DkdHGuu774oXR2eMw/OBPo9X5LcqfT0Zt9k1xDrPfdG9PGfQZKy7FVXtrUPhK2gBkhZigHuAI30wZVddyAWq8OtUagzRx6GQKMxpdCt/MwKUV1FxJjy9tpfk3GWooWDP2mhY/aTMiH8RM41f30vIgOoUnYOGc2XOD0/5Jjl9t4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517851; c=relaxed/simple;
	bh=EiStlN/2YpED+vS6GOcb4YU5QeJV7JfMwxXUv4Dnsok=;
	h=Date:To:From:Subject:Message-Id; b=WokqV7PvdHp67LWVQcL4ZJXYLCYl6TGLYJCPHnY+w3iAGZ4edw+Ls556F2Tjqu8z8n6sR52UO7T63CrxpgaV2Rw46N+wA6AVnjs07M1eKagRD6JdLGUVnQASZPKypltXEpF+EJw70LtXzrQ+ltOMClpt7lavz6hVWqT7dw+MrBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P9nFlKvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P9nFlKvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7BAC113D0;
	Tue, 23 Dec 2025 19:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517851;
	bh=EiStlN/2YpED+vS6GOcb4YU5QeJV7JfMwxXUv4Dnsok=;
	h=Date:To:From:Subject:From;
	b=P9nFlKvMkj4O3YH31epfsjZFJCRKxE+Mhqa5idILcRuYwp8RYAWmsDrJ6uZUuClwe
	 /qZWMR2YKj0InIryTMVF3XDu//uAXF4kGEdmsJbeup1x0pmZIcGWO+AtRq/0FtyyfE
	 gvcFILApmBtA6hEm7d147tyL5zMbsyhGXi8Guzfg=
Date: Tue, 23 Dec 2025 11:24:10 -0800
To: mm-commits@vger.kernel.org,sln@onemain.com,martink@posteo.de,hverkuil@kernel.org,carlos.bilbao@kernel.org,wangyl5933@chinaunicom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-remove-one-of-the-entries-for-wangyuli.patch removed from -mm tree
Message-Id: <20251223192411.5B7BAC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .mailmap: remove one of the entries for WangYuli
has been removed from the -mm tree.  Its filename was
     mailmap-remove-one-of-the-entries-for-wangyuli.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -858,7 +858,6 @@ Vladimir Davydov <vdavydov.dev@gmail.com
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
 WangYuli <wangyuli@aosc.io> <wangyl5933@chinaunicom.cn>
 WangYuli <wangyuli@aosc.io> <wangyuli@deepin.org>
-WangYuli <wangyuli@aosc.io> <wangyuli@uniontech.com>
 Weiwen Hu <huweiwen@linux.alibaba.com> <sehuww@mail.scut.edu.cn>
 WeiXiong Liao <gmpy.liaowx@gmail.com> <liaoweixiong@allwinnertech.com>
 Wen Gong <quic_wgong@quicinc.com> <wgong@codeaurora.org>
_

Patches currently in -mm which might be from wangyl5933@chinaunicom.cn are


