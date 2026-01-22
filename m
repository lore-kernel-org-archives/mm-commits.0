Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718D2392C3C
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 19:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769110207; cv=none; b=Iapcz/PtlFp1OFRYdqnUF45PXKLRwyIfvFTM02MO3lPeMHolFjzI61NFkpGTprJHhrVEpEcV+xi7EcdX9/YUinqSI/FFEWAY1eNCNEML9YiwdYIKOmP1QfCBMmkdoz+r8ETs6FvAYwvKYriD7dHSB6sDpvVaGiydgyvhfR20t3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769110207; c=relaxed/simple;
	bh=247bz2FdDN31GB91fT/IQxp8jlDoOGQKtFtNmj1z+6Q=;
	h=Date:To:From:Subject:Message-Id; b=AXb/ZrR7Jh2C00JEl3HXz0Ny9Co3Wrq/CEqB4846cnW4Qx0nfICs/C5ikSUqChP6i/SmKjC9guqTtUK9Dw/zd9SuGR0PQmshWi0imn4J8oEUAsZSlGiuHfVhngBeLJiPyfwxByuCVs4F5ZeCka0ghN68Qck+B56QBneuWn2zxZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BzMdzG/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BzMdzG/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CA3C116C6;
	Thu, 22 Jan 2026 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769110205;
	bh=247bz2FdDN31GB91fT/IQxp8jlDoOGQKtFtNmj1z+6Q=;
	h=Date:To:From:Subject:From;
	b=BzMdzG/pvitJCCaq9kLrDu4ORbQwZ7lnXAuk/vb3ZvD6w+X3PC7U9a2jhdn80dgaI
	 jFjM/gfolDsaJ1HgMkyAy2r86/5N5z2Dn6y6+rEIDtj3m3Nu5baUX43JrH4RlwFjv0
	 LqNzqaK/Su+sTy9H5LutI4hFopf1xr5NO21+Ay2g=
Date: Thu, 22 Jan 2026 11:30:04 -0800
To: mm-commits@vger.kernel.org,bigeasy@linutronix.de,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mm_init-dont-cond_resched-in-deferred_init_memmap_chunk-if-called-from-deferred_grow_zone.patch removed from -mm tree
Message-Id: <20260122193005.82CA3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: Don't cond_resched() in deferred_init_memmap_chunk() if called from deferred_grow_zone()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-dont-cond_resched-in-deferred_init_memmap_chunk-if-called-from-deferred_grow_zone.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
Return-Path: <longman@redhat.com>
X-Spam-Checker-Version: SpamAssassin 4.0.0 (2022-12-13) on hp2
X-Spam-Level: 
X-Spam-Status: No, score=-101.5 required=2.5 tests=BAYES_00,
	USER_IN_WELCOMELIST autolearn=ham autolearn_force=no version=4.0.0
X-Original-To: akpm@localhost
Delivered-To: akpm@localhost
Received: from hp2 (localhost [127.0.0.1])
	by hp2.hsd1.ca.comcast.net (Postfix) with ESMTP id BDA3316C240C
	for <akpm@localhost>; Thu, 22 Jan 2026 10:45:05 -0800 (PST)
Received: from imap.fastmail.com [103.168.172.58]
	by hp2 with IMAP (fetchmail-6.4.38)
	for <akpm@localhost> (single-drop); Thu, 22 Jan 2026 10:45:05 -0800 (PST)
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	 by slotpi18m23 (Cyrus 3.13.1-53-g2aa1cf9b95-fm-20260111.001-g2aa1cf9b) with LMTPA;
	 Thu, 22 Jan 2026 13:44:35 -0500
X-Cyrus-Session-Id: slotpi18m23-1769107475-1313660-2-9377622233328828852
X-Sieve: CMU Sieve 3.0
X-Resolved-to: akpm@mbx.kernel.org
X-Delivered-to: akpm@mbx.kernel.org
X-Original-Delivered-to: akpm@linux-foundation.org
X-Mail-from: longman@redhat.com
Received: from phl-mx-03 ([10.202.2.202])
  by phl-compute-05.internal (LMTPProxy); Thu, 22 Jan 2026 13:44:35 -0500
Received: from phl-mx-03.messagingengine.com (localhost [127.0.0.1])
	by mailmx.phl.internal (Postfix) with ESMTP id AB6564BA2E4F
	for <akpm@mbx.kernel.org>; Thu, 22 Jan 2026 13:44:35 -0500 (EST)
Received: from mailmx.phl.internal (localhost [127.0.0.1])
    by phl-mx-03.messagingengine.com (Authentication Milter) with ESMTP
    id 2DA772CE6F3.EBC004BA2EA3;
    Thu, 22 Jan 2026 13:44:35 -0500
ARC-Seal: i=3; a=rsa-sha256; cv=pass; d=messagingengine.com; s=fm2; t=
    1769107475; b=v1PQznBroGc1AasidLwLCn9ToWuJSCOXxj+PCHLAB+gnhBASbi
    HH1lCMJOkxEBdJvt7z9b7f0c7VgQv/zxvBFYjO6zEyBi7DXTayyagcv/vnBwSSBG
    JUC4rQ5fG+8r3zcwhseLb1gLPrbJAJaCPviBXaU4bUkKc7Fk9BwD/7vAHz5oZD3u
    zm5cdboAZ05thv+4yn+B6lVlFRJVKzf8JS3neVd6SrbSFp0aKX1jN+nrzZCpwlGE
    LXMCRhnfYfjAsA+3+pUGeRreAAvN8q1zqcN6baYPk6OcMYBe49CWyqS9g4pgfpgX
    td6i4BKGgOxJplFJ3+k/0o6m6k3YbbfKD7aQ==
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=
    messagingengine.com; h=from:to:cc:subject:date:message-id
    :mime-version:content-transfer-encoding; s=fm2; t=1769107475;
    bh=2hi9nw0ROEqCJmA86cR5BCja4mz2cFCx+tgdx6SAHhI=; b=M2/15mKNuU70
    uTTnhUqk0D+6+8mStd37shgVzAeJVXy0WVoC1XxXKP2k5Hc54nvVRvQKLFjHc2j1
    yXGI6Vk10wW6Dszua02dno11CqQwHzxnJXWE4h9NL08aj/fl/un7nQbUmWq5GZKr
    TqVeaUpl2CTdtyoXHn4pyFdgtOlSHJn06NP76lexBTKQyv3KJTVT6IJy6DhClYLC
    Ry4qIdFyoE/v3uIMmCvGLvg/zl7dhFvC12S5KZTXIxopkUA64t2T0ckq3Oy40N9K
    HWk5vTMSO/siPmMXMQadflDnMCbEABtYARyzSnBX9t+poVX8j+7irD1Qj5pd9XwP
    xXLZgUnRaw==
ARC-Authentication-Results: i=3; phl-mx-03.messagingengine.com;
    x-csa=none;
    x-me-sender=none;
    x-ptr=pass smtp.helo=mail-qv1-f72.google.com
    policy.ptr=mail-qv1-f72.google.com;
    bimi=none (No BIMI records found);
    arc=pass
    (as.2.google.com=pass, ams.2.google.com=pass, as.1.google.com=pass, ams.1.google.com=pass)
    smtp.remote-ip=209.85.219.72;
    x-arc-dkim=pass header.i=@redhat.com header.s=mimecast20190719
    header.b=TDdE14Dk x-arc-instance=1 x-arc-domain=google.com
    (Trusted from aar.1.google.com);
    x-arc-dkim=pass header.i=@redhat.com header.s=mimecast20190719
    header.b=TDdE14Dk x-arc-instance=2 x-arc-domain=google.com
    (Trusted from aar.2.google.com);
    x-arc-dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE)
    header.from=redhat.com x-arc-instance=1 x-arc-domain=google.com
    (Trusted from aar.1.google.com);
    x-arc-dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE)
    header.from=redhat.com x-arc-instance=2 x-arc-domain=google.com
    (Trusted from aar.2.google.com);
    x-arc-spf=pass
    (google.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender)
    smtp.mailfrom=longman@redhat.com x-arc-instance=1
    x-arc-domain=google.com (Trusted from aar.1.google.com);
    x-arc-spf=pass
    (google.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender)
    smtp.mailfrom=longman@redhat.com x-arc-instance=2
    x-arc-domain=google.com (Trusted from aar.2.google.com);
    dkim=pass (1024-bit rsa key sha256) header.d=redhat.com
    header.i=@redhat.com header.b=TDdE14Dk header.a=rsa-sha256
    header.s=mimecast20190719;
    dmarc=pass policy.dwl=pass policy.published-domain-policy=quarantine
    policy.applied-disposition=none policy.evaluated-disposition=none
    (p=quarantine,d=none,d.eval=none) policy.policy-from=p
    header.from=redhat.com;
    iprev=pass smtp.remote-ip=209.85.219.72 (mail-qv1-f72.google.com);
    spf=pass smtp.mailfrom=longman@redhat.com
    smtp.helo=mail-qv1-f72.google.com
X-ME-Authentication-Results: phl-mx-03.messagingengine.com;
    x-tls=pass smtp.version=TLSv1.3 smtp.cipher=TLS_AES_256_GCM_SHA384
      smtp.bits=256/256;
    x-vs=clean score=-100 state=0
Authentication-Results: phl-mx-03.messagingengine.com;
    x-csa=none;
    x-me-sender=none;
    x-ptr=pass smtp.helo=mail-qv1-f72.google.com
      policy.ptr=mail-qv1-f72.google.com
Authentication-Results: phl-mx-03.messagingengine.com;
    bimi=none (No BIMI records found)
Authentication-Results: phl-mx-03.messagingengine.com;
    arc=pass
      (as.2.google.com=pass, ams.2.google.com=pass, as.1.google.com=pass, ams.1.google.com=pass)
      smtp.remote-ip=209.85.219.72;
    x-arc-dkim=pass header.i=@redhat.com header.s=mimecast20190719
      header.b=TDdE14Dk x-arc-instance=1 x-arc-domain=google.com
      (Trusted from aar.1.google.com);
    x-arc-dkim=pass header.i=@redhat.com header.s=mimecast20190719
      header.b=TDdE14Dk x-arc-instance=2 x-arc-domain=google.com
      (Trusted from aar.2.google.com);
    x-arc-dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE)
      header.from=redhat.com x-arc-instance=1 x-arc-domain=google.com
      (Trusted from aar.1.google.com);
    x-arc-dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE)
      header.from=redhat.com x-arc-instance=2 x-arc-domain=google.com
      (Trusted from aar.2.google.com);
    x-arc-spf=pass
      (google.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender)
      smtp.mailfrom=longman@redhat.com x-arc-instance=1
      x-arc-domain=google.com (Trusted from aar.1.google.com);
    x-arc-spf=pass
      (google.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender)
      smtp.mailfrom=longman@redhat.com x-arc-instance=2
      x-arc-domain=google.com (Trusted from aar.2.google.com)
Authentication-Results: phl-mx-03.messagingengine.com;
    dkim=pass (1024-bit rsa key sha256) header.d=redhat.com
      header.i=@redhat.com header.b=TDdE14Dk header.a=rsa-sha256
      header.s=mimecast20190719;
    dmarc=pass policy.dwl=pass policy.published-domain-policy=quarantine
      policy.applied-disposition=none policy.evaluated-disposition=none
      (p=quarantine,d=none,d.eval=none) policy.policy-from=p
      header.from=redhat.com;
    iprev=pass smtp.remote-ip=209.85.219.72 (mail-qv1-f72.google.com);
    spf=pass smtp.mailfrom=longman@redhat.com
      smtp.helo=mail-qv1-f72.google.com
X-ME-VSCause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeileduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkggfgsedtkeertddttddtnecuhfhrohhmpeghrghimhgrnhcunfho
    nhhguceolhhonhhgmhgrnhesrhgvughhrghtrdgtohhmqeenucggtffrrghtthgvrhhnpe
    euleduuedufeeilefgfedtgfdthffgheektdegffeluddtffehhfffhedvhfeutdenucff
    ohhmrghinhepshgvsggrshhtihgrnhdrmhhmnecukfhppedvtdelrdekhedrvdduledrje
    dvpdehgedrudekiedrudelkedrieefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehinhgvthepvddtledrkeehrddvudelrdejvddphhgvlhhopehmrghilhdqqhhvud
    dqfhejvddrghhoohhglhgvrdgtohhmpdhmrghilhhfrhhomhepoehlohhnghhmrghnsehr
    vgguhhgrthdrtghomheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepoegrkhhpmh
    esmhgsgidrkhgvrhhnvghlrdhorhhgqe
X-ME-VSScore: -100
X-ME-VSCategory: clean
X-ME-CSA: none
X-ME-Received: <xmx:E3ByaXZty7bIJdWfCI3SPtqJR8VzKGuborapCkdzKj-ktmOZoW81Gg>
X-ME-Received: <xmx:E3ByaUU9MLkVpwv6a8GwwKkOHw9U4W4jwbVZMhX53hYhEYbO-VXYqg>
Received-SPF: pass
    (redhat.com ... 73t7ezjz._spf._d.mim.ec: Sender is authorized to use 'longman@redhat.com' in 'mfrom' identity (mechanism 'include:73t7ezjz1._spf._d.mim.ec' matched))
    receiver=phl-mx-03.messagingengine.com;
    identity=mailfrom;
    envelope-from="longman@redhat.com";
    helo=mail-qv1-f72.google.com;
    client-ip=209.85.219.72
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by phl-mx-03.messagingengine.com (Postfix) with ESMTPS id EBC004BA2EA3
	for <akpm@mbx.kernel.org>; Thu, 22 Jan 2026 13:44:34 -0500 (EST)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-890587d4e87so46661876d6.0
        for <akpm@mbx.kernel.org>; Thu, 22 Jan 2026 10:44:34 -0800 (PST)
ARC-Seal: i=2; a=rsa-sha256; t=1769107473; cv=pass;
        d=google.com; s=arc-20240605;
        b=VoRgigHN5rw6W1wbknYTZlVBq5EEbDLMYCHJzkl+wj2tC+NBHQ3rVHB7cbefOlrwqW
         q1nGxRrxIWkr4QwXdv7V0IhqLcdB96Q0U/elkz1aL+luajaoJISQh0zZaobYQt61Spaz
         G536bgFhwBJ8FLfaCzNmDUdR1tAg2TNKIJhiR86ON8hPwlhvjJXeX3PoLYuCIznbcSG1
         k5DcRtv2QH2C9Nm4iWcDpASjkoq7J9bWQVOWLjpdfbyvuqqvOmfkDd1LqcX0X3s/5MUI
         7qC2DboiFy/etj56N7CJqAyv6ZGzbEywgde/+PQADlI95KhUrs3Ec9ByoHHRS1LYddfA
         DSAg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature;
        bh=2hi9nw0ROEqCJmA86cR5BCja4mz2cFCx+tgdx6SAHhI=;
        fh=geqB8KoqUXnXfV3fAhrOdYBU2wscEQPV2w/oq1ZqSrs=;
        b=FQgB9F77/21rSHpEasJ7pfkm0MbxQtVYQmfXpqrFYkMZ6QMSzFvVr+luL9S0ROj5ye
         lDRgRhH7gZ852Yi3aN9+DWjPHtwoo+vKC7PS8mF0mKUnvwxUi7/0Nv+eYlyK15XAv8bp
         bqXxioqeBcsn8s44IBdpbWUgks0/h0lZtc+IYl4NZBEzamQnLwHgL5YQfXVcByk6Ntwg
         NGfeeDWFbp+oGwB/5sPvuby6rVSpV28DXQHuHmnDmq+J5acPApvvNRqtEsUicG5cc3K4
         DLEi4PTWdLob/gPbbEDkhC7/Q6mM6W18Cl/sbYXpV/OcuoZmxM3ihrZhxkBDUcC7ANlT
         qzUg==;
        dara=google.com
ARC-Authentication-Results: i=2; mx.google.com;
       dkim=pass header.i=@redhat.com header.s=mimecast20190719 header.b=TDdE14Dk;
       spf=pass (google.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=redhat.com
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769107473; x=1769712273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2hi9nw0ROEqCJmA86cR5BCja4mz2cFCx+tgdx6SAHhI=;
        b=Z4RDnFSaKdvt9kG69toCW6gbBqshNXnO2BjYM9TmptoJTOhP49OoK8qnhGnXYEJdWa
         EYBdNOzz03mxxfpCQIN/yPu9Ay8oJK6jIxCzdK0j8PHjPePaqpl+IRLKW+DV/3piLfQQ
         9cm8KtjXbZ7Wk0Qj+CQX3PPoi3jNJF+cSRKtmHD8Tb0IDl1Q1y8yxltIKAwpfiX5m5VB
         awSSuYQoFBqJgzl0FVKRbtZbe/nZ2dK4fPJkejtKzmXwrMqR0suf9sFf6HYIjEiLJmE9
         NUTffxEG6MaeqLHmJXYxqKnogNSacZWGxHRgcHLDxh7pJmKfhvw2iCGI5bxaL+CIneoh
         b8Wg==
X-Forwarded-Encrypted: i=2; AJvYcCWdNXXW9S1BpvQiQln6x35QrNK1hBwKhrLOAKGUHy7varg9aeE+bIIIFLDiv+sopUqOJVqG@mbx.kernel.org
X-Gm-Message-State: AOJu0Yzz78hkzGXKN/zxl4+txTmHzBl+e+5Ki4SHzR1huj5rgOvRP+6Y
	I5/U76EWbxpz36xYqw0qnK9sOCqA1bVKDwCpj9tF2Q0mCkFum9x8GRaVQkz7skh3ArtsN/+JwLh
	B5xE4KnrTHB5fc2ybBJt3775zrwp8nEnQYY6PhqLVOVOfr9zJwzlT+2CE6AWtfyb2xRopGZ6Az5
	/epuU79DXgxw25RRSt3Lqxtw==
X-Gm-Gg: AZuq6aJ/uqQu9U5oOSRD8+D9OWy4amIuew0Va9xOAeQrZTs2yfNeY+54SCh76W1iH8U
	2Xs0Vi78md4k6fHgJP9KwDx38vmvV5I3R+UknaO1p5A7eoqXNeP2WLz9+o4DCDkJmrpudFs6lx9
	4TKohpe4GuQfxrh/fxfbwnDpFZgdKiUn8kwmbnrE00z12U+XnG8uCsOcX0qmj4cTu1njB5LFK6S
	sntWCqpGyaDFQj16C3P6Wal5sfHqdX/XwyMAWocjVsiNRg7a7ThMgx/xGlFNNQuUaHQRAqaS/d7
	+lv8RQ5S3V4wSr00G1bskes7t70ksmCqrde9+cMlzfKRwjXV3GJj7FS0L+S/xDcSYdFQagR+34P
	yP8i9U6HbbPLEXFrQZSGEWZ4kEJnvRCN5v1Zn1AlX+V5NKXoVApgoEX8T
X-Received: by 2002:a05:6214:dae:b0:894:6608:97b8 with SMTP id 6a1803df08f44-89490163300mr7326506d6.10.1769107473598;
        Thu, 22 Jan 2026 10:44:33 -0800 (PST)
X-Received: by 2002:a05:6214:dae:b0:894:6608:97b8 with SMTP id 6a1803df08f44-89490163300mr7326046d6.10.1769107473117;
        Thu, 22 Jan 2026 10:44:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769107473; cv=none;
        d=google.com; s=arc-20240605;
        b=SnEdxnxyoJNjoxRUdm1E1NWSswLxlPsWobQNBRLkMZh/ENPli98X+fnynP3OrYBaPD
         PdMeAyYL5l73sFaQ3IQH4U1PTr7yAiTKWgDloP8mSlgrjoDcjgKohAVpzZO6ooJ2M2SR
         nkVjVJSKOxawA1Tv9qzQq0jbH9nHIEYRvP+wXGDhZTh0ZdjpQMbskKWf8tnXGo1iNqXA
         k04KuHbxZ4Dgz6AOOY1heqyuxzppGQQWLFqrsTXDSeAj4nKMjiQaolb+DIZ6dLHACNBJ
         VW4UaS80S2CDa357UCDL+MMIM+os0Mks876Tr57Cvq396MJRoxERrTxYtyj+JMyy80Oe
         vf9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature;
        bh=2hi9nw0ROEqCJmA86cR5BCja4mz2cFCx+tgdx6SAHhI=;
        fh=uPYCD+JvrwK2jRr5CiS8PAtE/krO+VK2aF2iiSdwgZ4=;
        b=AjUTewijWx4SsY8rgvrSiUGhTq7Pz33bxZ2zwM293aBfFniiHGhIG4U23JG9DAa8AO
         Vgp8PmSuwfN2Wgq9gwQszHd3zgAWnGMAK8R+6mplOPICJpY9lfnWExZ7PpNYKmgXDDwH
         4gY8i8qXqmpS1ZMuwqaESbTm2R8ttDY4tAl2LoU31gsh9P2xu71atAJ/GOS1HJANYUKX
         XvGSW3r23vYZ5IzjKESdb2bT10lPcONb7Ensxpgzk3NMB4AV+EObfZ5i51fx/l4qnyJQ
         nkWwhgRCgmhfP5kmd9SgCZSoixvJHer5mJX0P5TetFydknaFLzLrftiSyJYpSXyxHJxM
         RGJQ==;
        dara=google.com
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@redhat.com header.s=mimecast20190719 header.b=TDdE14Dk;
       spf=pass (google.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=redhat.com
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com. [170.10.133.124])
        by mx.google.com with ESMTPS id 6a1803df08f44-894919650c5si530686d6.638.2026.01.22.10.44.33
        for <akpm@linux-foundation.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 10:44:33 -0800 (PST)
Received-SPF: pass (google.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) client-ip=170.10.133.124;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@redhat.com header.s=mimecast20190719 header.b=TDdE14Dk;
       spf=pass (google.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769107472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2hi9nw0ROEqCJmA86cR5BCja4mz2cFCx+tgdx6SAHhI=;
	b=TDdE14DkowbjfJAbLE4KmpwfGAH8GFQmh7rLNqaS07K4xgZqsbK6wYKEGi/sM+B2obCyeN
	wvzQ1AkU7yq553UivaL2Bl1LGrRy8LNmBr+d2iFeji4DqY3QUplBmRAG+q8dK/x4I2cIJt
	P9F6TY64pJeMnqxLu1qZ2LcjnrofMaU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-DrPRUB-MMeeByGpbTwLtaw-1; Thu,
 22 Jan 2026 13:44:27 -0500
X-MC-Unique: DrPRUB-MMeeByGpbTwLtaw-1
X-Mimecast-MFC-AGG-ID: DrPRUB-MMeeByGpbTwLtaw_1769107465
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6209F1955D9F;
	Thu, 22 Jan 2026 18:44:25 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.90.13])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EBA041800665;
	Thu, 22 Jan 2026 18:44:22 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: mm/mm_init: Don't cond_resched() in deferred_init_memmap_chunk() if called from deferred_grow_zone()
Date: Thu, 22 Jan 2026 13:43:43 -0500
Message-ID: <20260122184343.546627-1-longman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Gm-Original-To: akpm@linux-foundation.org

Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
in deferred_grow_zone()") made deferred_grow_zone() call
deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
section with irqs disabled. It did check for irqs_disabled() in
deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
interrupt but rcu_read_lock() is called. This leads to the following
bug report.

  BUG: sleeping function called from invalid context at mm/mm_init.c:2091
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  RCU nest depth: 1, expected: 0
  3 locks held by swapper/0/1:
   #0: ffff80008471b7a0 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x28/0x40
   #1: ffff003bdfffef48 (&pgdat->node_size_lock){+.+.}-{3:3}, at: deferred_grow_zone+0x140/0x278
   #2: ffff800084acf600 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1b4/0x408
  CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.19.0-rc6-test #1 PREEMPT_{RT,(full)
}
  Tainted: [W]=WARN
  Call trace:
   show_stack+0x20/0x38 (C)
   dump_stack_lvl+0xdc/0xf8
   dump_stack+0x1c/0x28
   __might_resched+0x384/0x530
   deferred_init_memmap_chunk+0x560/0x688
   deferred_grow_zone+0x190/0x278
   _deferred_grow_zone+0x18/0x30
   get_page_from_freelist+0x780/0xf78
   __alloc_frozen_pages_noprof+0x1dc/0x348
   alloc_slab_page+0x30/0x110
   allocate_slab+0x98/0x2a0
   new_slab+0x4c/0x80
   ___slab_alloc+0x5a4/0x770
   __slab_alloc.constprop.0+0x88/0x1e0
   __kmalloc_node_noprof+0x2c0/0x598
   __sdt_alloc+0x3b8/0x728
   build_sched_domains+0xe0/0x1260
   sched_init_domains+0x14c/0x1c8
   sched_init_smp+0x9c/0x1d0
   kernel_init_freeable+0x218/0x358
   kernel_init+0x28/0x208
   ret_from_fork+0x10/0x20

Fix it adding a new argument to deferred_init_memmap_chunk() to
explicitly tell it if cond_resched() is allowed or not instead of
relying on some current state information which may vary depending
on the exact kernel configuration options that are enabled.

Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Waiman Long <longman@redhat.com>
---

 [v3]: Add a new can_resched argument to deferred_init_memmap_chunk() as
       suggested by Sebastian.

 mm/mm_init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f..2a809cd8e7fa 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2059,7 +2059,7 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
  */
 static unsigned long __init
 deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
-			   struct zone *zone)
+			   struct zone *zone, bool can_resched)
 {
 	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = 0;
@@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 
 			spfn = chunk_end;
 
-			if (irqs_disabled())
-				touch_nmi_watchdog();
-			else
+			if (can_resched)
 				cond_resched();
+			else
+				touch_nmi_watchdog();
 		}
 	}
 
@@ -2101,7 +2101,7 @@ deferred_init_memmap_job(unsigned long start_pfn, unsigned long end_pfn,
 {
 	struct zone *zone = arg;
 
-	deferred_init_memmap_chunk(start_pfn, end_pfn, zone);
+	deferred_init_memmap_chunk(start_pfn, end_pfn, zone, true);
 }
 
 static unsigned int __init
@@ -2216,7 +2216,7 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
 	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
 	     spfn = epfn, epfn += PAGES_PER_SECTION) {
-		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
+		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone, false);
 	}
 
 	/*
-- 
2.52.0

Patches currently in -mm which might be from longman@redhat.com are


