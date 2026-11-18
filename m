Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980524;
	b=cJt2VRWB/RLOA9KWqu7Ki1HEwPRE+/VglZXqvsoNI+GVav7UQHdzO+U0A2gGphc90NUx
	 rCoaRE8xmFmTx43jhRhNIRqJfi0+/BxRtv7uY2+qnR6SwvJFec2U0WIXo2vSCMcCjuqVl
	 wuP4QX/8w1SujflLW2zJyZ65p5l/ciHlUihJ9VTXGIY18wlCZwh/0S7yPE3xXUUM38RkH
	 NmXUIBD24rAJXSXy4WA1rHrGrKGMo5iZbhHtapP2+waX5TmO/3D17fbNBwummauCUWWXQ
	 pADSC7ReVOQ8/8rdzH1Z4IeJnVXff+K8tUXCjYvycVTD1uygo2P237IYyPHqS6K46tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980524;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bOOjNsczpyCLDF1HpeFvdPLtspfP10jEemOsUXGf120=;
	b=o3tLaoYOCy/6CdSyqXgOzOWZarGWVICQR9JmNxNiHLRbswgwq2TreicgjmCvFeiVJpbq
	 na4QnHsn3HL8dK1iDPiXTUphXxb9WotQxOggyHCETYfcRxHUA1TDpOk+EsWpj9KTghlDm
	 MtL8sYo5f/GBX/h4EMLbd+WI3V2wYq4FhfoK/r7f2IK5/LyFnAUICRKJ+QS2Uap3VoHOe
	 eB6tF5uMC3/5B1cOQzD8X8GqBv9xIzueId8bCjRyMzTLyHiX+nx/Uk7mUEXVyVpbY+fzX
	 dgRuQumqQHhHFLRw8iEnKW84lIvoxcuBESHV05XhUmJvevno+cvMHS3kMM38MYaWFSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PrRkDB4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E94606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PrRkDB4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2718B1F0033C;
	Wed, 18 Nov 2026 05:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980524;
	bh=bOOjNsczpyCLDF1HpeFvdPLtspfP10jEemOsUXGf120=;
	h=Date:To:From:Subject;
	b=PrRkDB4+d0D8eB//9PW977yUh7irrNIfOPiwXLORCE/Wj5oIcHVIDj+FACaBYhao+
	 FLZ4nwUdfHgnoWA6XLUvXpn7V3wjeGrq93+kK2jHt83xnchZqcNMsM4ih89b8MBmaI
	 ggRzOdK7r6kpD2IG2CUc1306AgMG77Kj2ANEoUek=
Date: Tue, 17 Nov 2026 21:42:03 -0800
To: mm-commits@vger.kernel.org,wangyibo@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-add-wang-yibos-work-email-address.patch removed from -mm tree
Message-Id: <20261118054204.2718B1F0033C@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: add Wang Yibo's work email address
has been removed from the -mm tree.  Its filename was
     mailmap-add-wang-yibos-work-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yibo <wangyibo@kylinos.cn>
Subject: mailmap: add Wang Yibo's work email address
Date: Mon,  9 Nov 2026 11:06:51 +0800

My kernel work will be signed off with my company address from now on.
Add it to .mailmap and map the personal address I used before to it, so
that both resolve to the same author in git log and git shortlog.

Link: https://lore.kernel.org/20261109030651.2289573-1-wangyibo@kylinos.cn
Signed-off-by: Wang Yibo <wangyibo@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-wang-yibos-work-email-address
+++ a/.mailmap
@@ -1012,6 +1012,7 @@ Vlad Dogaru <ddvlad@gmail.com> <vlad.dog
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
 Vlastimil Babka <vbabka@kernel.org> <vbabka@suse.cz>
+Wang Yibo <wangyibo@kylinos.cn> <szwyb123@gmail.com>
 WangYuli <wangyuli@aosc.io> <wangyl5933@chinaunicom.cn>
 WangYuli <wangyuli@aosc.io> <wangyuli@deepin.org>
 Wei Wang <weiwan@google.com> <weibunny@fb.com>
_

Patches currently in -mm which might be from wangyibo@kylinos.cn are


