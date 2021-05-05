Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,LONGWORDS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BC1C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 17:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C393261157
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 17:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhEERqO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 May 2021 13:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235455AbhEERpA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 5 May 2021 13:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 195DA608FE;
        Wed,  5 May 2021 17:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620236642;
        bh=tGbFnJmg8Ig2uqhLvHnYrV+AXgOJyfOmDQdW5KgM1x8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v7ckU1zbhJDEfNrjKdgt/VV2IIXCKhd5u+nYcrdTHFqZlK+qKx1ITR555R9DlPXI0
         aTyIsL445nI3y2cM72MXH82EKevy0LBP+UNM0mLB0gjCmZIFFnaP0PYEqB9eF0Af2w
         JsJm3t9+38Gktttt/95gZpIejxx8uDo7WxwewFbM=
Date:   Wed, 5 May 2021 10:44:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: incoming
Message-Id: <20210505104401.75fc14e7de7573c26c4c49d4@linux-foundation.org>
In-Reply-To: <CAHk-=wgOGM5u0Kcx0L0u58D9ms6vQ=LwtJNMNd4xmAjQ+jcQSw@mail.gmail.com>
References: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
        <CAHk-=wjzDtUVs9To0nMerMt-XDiP3JH2ee=1A9z+0onQaFD4KQ@mail.gmail.com>
        <20210504201608.5e5f94e76f7eed7264285c28@linux-foundation.org>
        <CAHk-=wgOGM5u0Kcx0L0u58D9ms6vQ=LwtJNMNd4xmAjQ+jcQSw@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__5_May_2021_10_44_01_-0700_LsVOFQr+Xs5/FBnR"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__5_May_2021_10_44_01_-0700_LsVOFQr+Xs5/FBnR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 May 2021 10:10:33 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, May 4, 2021 at 8:16 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Let me resend right now with the same in-reply-to.  Hopefully they will
> > land in the correct place.
> 
> Well, you re-sent it twice, and I have three copies in my own mailbox,
> bot they still don't show up on the mm-commits mailing list.
> 
> So the list hates them for some odd reason.
> 
> I've picked them up locally, but adding Konstantin to the participants
> to see if he can see what's up.
> 
> Konstantin: patches 103/106/107 are missing on lore out of Andrew's
> series of 143. Odd.

It's weird.  They don't turn up on linux-mm either, and that's running
at kvack.org, also majordomo.  They don't get through when sent with
either heirloom-mailx or with sylpheed.

Also, it seems that when Anshuman originally sent the patch, linux-mm
and linux-kernel didn't send it back out.  So perhaps a spam filter
triggered?

I'm seeing

https://lore.kernel.org/linux-arm-kernel/1615278790-18053-3-git-send-email-anshuman.khandual@arm.com/

which is via linux-arm-kernel@lists.infradead.org but the linux-kernel
server massacred that patch series.  Searching
https://lkml.org/lkml/2021/3/9 for "anshuman" only shows 3 of the 7
email series.

One of the emails (as sent my me) is attached, if that helps.



--Multipart=_Wed__5_May_2021_10_44_01_-0700_LsVOFQr+Xs5/FBnR
Content-Type: text/plain;
 name="x.txt"
Content-Disposition: attachment;
 filename="x.txt"
Content-Transfer-Encoding: 7bit

Return-Path: <akpm@linux-foundation.org>
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on y
X-Spam-Level: (none)
X-Spam-Status: No, score=-101.5 required=2.5 tests=BAYES_00,T_DKIM_INVALID,
	USER_IN_WHITELIST autolearn=ham autolearn_force=no version=3.4.1
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by localhost.localdomain (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 1453H2fk032202
	for <akpm@localhost>; Tue, 4 May 2021 20:17:03 -0700
Received: from imap.fastmail.com [66.111.4.135]
	by localhost.localdomain with IMAP (fetchmail-6.3.26)
	for <akpm@localhost> (single-drop); Tue, 04 May 2021 20:17:03 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	 by sloti11d1t06 (Cyrus 3.5.0-alpha0-442-g5daca166b9-fm-20210428.001-g5daca166) with LMTPA;
	 Tue, 04 May 2021 23:16:31 -0400
X-Cyrus-Session-Id: sloti11d1t06-1620184591-1699471-2-6359664467419938249
X-Sieve: CMU Sieve 3.0
X-Resolved-to: akpm@mbx.kernel.org
X-Delivered-to: akpm@mbx.kernel.org
X-Mail-from: akpm@linux-foundation.org
Received: from mx6 ([10.202.2.205])
  by compute1.internal (LMTPProxy); Tue, 04 May 2021 23:16:31 -0400
Received: from mx6.messagingengine.com (localhost [127.0.0.1])
	by mailmx.nyi.internal (Postfix) with ESMTP id 40796C800E1
	for <akpm@mbx.kernel.org>; Tue,  4 May 2021 23:16:31 -0400 (EDT)
Received: from mx6.messagingengine.com (localhost [127.0.0.1])
    by mx6.messagingengine.com (Authentication Milter) with ESMTP
    id 14870833D7F;
    Tue, 4 May 2021 23:16:31 -0400
ARC-Seal: i=2; a=rsa-sha256; cv=pass; d=messagingengine.com; s=fm2; t=
    1620184591; b=FBo7Gf3JFN+4QYg5Byan0oNm6RESv+sIf5HcaslVNsUd9SOTGS
    yI0+IsXr1CUpGH783hE6fmgEq9SyfOwQVZjdikLaJS1+7u0JtfAYQFU3RORCtXlr
    djJWrScfjVa8nAHX4rQCtzvtPYuzx5w7cTgGgeILgoJMxgLj7EC9xcT8BIf68+9W
    Lw+ohAmcuiKhL2ez+de4SMuwdh3dh2FwAIHQOsSjEU1/NV+WGxMLwYbxWgTrqQGH
    RQIzFNdq30qslW9huK47+e80uHOX2tXwxtshwbThFEn458bdV5LL6Y8Oh4ZWMbv1
    tFgTt515DVedonZknxc07XsXtAjaJyB8bfHw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=
    messagingengine.com; h=date:from:to:subject:message-id
    :in-reply-to; s=fm2; t=1620184591; bh=LuH7mbm3+zp863vKBEqKeoZtnp
    uFxYpIb5oTVwf56Es=; b=m5E1fbz2b+an/X406oY3BuG0Zm4/W05vWAki8Lsnud
    gPCc1LfPUFSuXaMppcEDPbLKprp4hH3T52itK4pivXMQCLEOyme7kVStaLMVTiky
    Xxqh5ZdhOWvygBfda/GjfuLBSbbj2gfm8HPKpbL7CA5foelknIBhJHDzGkJyxetZ
    YagZfVvtdo2OEwnC1mmjUCpKPO5+m5kaZO0ol6rPdl+TV0MKGhjLg+/i6Ia+0nFp
    zDwV4VeACvVcGb2xY7KG5Z+BtqVxeVFn+w5JcqpWUtxEKoSBR4bWARzjwHg6eouh
    7psOOKPTt/NzDKk+3f49lso5KlPiTF2xEU/+5SIttCkQ==
ARC-Authentication-Results: i=2; mx6.messagingengine.com;
    arc=pass (as.1.google.com=pass, ams.1.google.com=pass)
    smtp.remote-ip=209.85.215.198;
    bimi=skipped (DMARC did not pass);
    dkim=pass (1024-bit rsa key sha256) header.d=linux-foundation.org
    header.i=@linux-foundation.org header.b=Gdz/3wY9 header.a=rsa-sha256
    header.s=korg x-bits=1024;
    dmarc=none policy.published-domain-policy=none
    policy.applied-disposition=none policy.evaluated-disposition=none
    (p=none,d=none,d.eval=none) policy.policy-from=p
    header.from=linux-foundation.org;
    iprev=pass smtp.remote-ip=209.85.215.198 (mail-pg1-f198.google.com);
    spf=pass smtp.mailfrom=akpm@linux-foundation.org
    smtp.helo=mail-pg1-f198.google.com;
    x-aligned-from=pass (Address match);
    x-arc-spf=pass
    (google.com: domain of akpm@linux-foundation.org designates 198.145.29.99 as permitted sender)
    smtp.mailfrom=akpm@linux-foundation.org x-arc-instance=1
    x-arc-domain=google.com (Trusted from aar.1.google.com);
    x-csa=none;
    x-google-dkim=fail (message has been altered, 2048-bit rsa key)
    header.d=1e100.net header.i=@1e100.net header.b=VZuDOxUf;
    x-me-sender=none;
    x-ptr=pass smtp.helo=mail-pg1-f198.google.com
    policy.ptr=mail-pg1-f198.google.com;
    x-return-mx=pass header.domain=linux-foundation.org policy.is_org=yes
    (MX Records found: ASPMX.L.GOOGLE.COM,ALT1.ASPMX.L.GOOGLE.COM,ALT2.ASPMX.L.GOOGLE.COM,ALT3.ASPMX.L.GOOGLE.COM,ALT4.ASPMX.L.GOOGLE.COM);
    x-return-mx=pass smtp.domain=linux-foundation.org policy.is_org=yes
    (MX Records found: ASPMX.L.GOOGLE.COM,ALT1.ASPMX.L.GOOGLE.COM,ALT2.ASPMX.L.GOOGLE.COM,ALT3.ASPMX.L.GOOGLE.COM,ALT4.ASPMX.L.GOOGLE.COM);
    x-tls=pass smtp.version=TLSv1.3 smtp.cipher=TLS_AES_256_GCM_SHA384
    smtp.bits=256/256;
    x-vs=clean score=40 state=0
Authentication-Results: mx6.messagingengine.com;
    arc=pass (as.1.google.com=pass, ams.1.google.com=pass)
      smtp.remote-ip=209.85.215.198;
    bimi=skipped (DMARC did not pass);
    dkim=pass (1024-bit rsa key sha256) header.d=linux-foundation.org
      header.i=@linux-foundation.org header.b=Gdz/3wY9 header.a=rsa-sha256
      header.s=korg x-bits=1024;
    dmarc=none policy.published-domain-policy=none
      policy.applied-disposition=none policy.evaluated-disposition=none
      (p=none,d=none,d.eval=none) policy.policy-from=p
      header.from=linux-foundation.org;
    iprev=pass smtp.remote-ip=209.85.215.198 (mail-pg1-f198.google.com);
    spf=pass smtp.mailfrom=akpm@linux-foundation.org
      smtp.helo=mail-pg1-f198.google.com;
    x-aligned-from=pass (Address match);
    x-arc-spf=pass
      (google.com: domain of akpm@linux-foundation.org designates 198.145.29.99 as permitted sender)
      smtp.mailfrom=akpm@linux-foundation.org x-arc-instance=1
      x-arc-domain=google.com (Trusted from aar.1.google.com);
    x-csa=none;
    x-google-dkim=fail (message has been altered, 2048-bit rsa key)
      header.d=1e100.net header.i=@1e100.net header.b=VZuDOxUf;
    x-me-sender=none;
    x-ptr=pass smtp.helo=mail-pg1-f198.google.com
      policy.ptr=mail-pg1-f198.google.com;
    x-return-mx=pass header.domain=linux-foundation.org policy.is_org=yes
      (MX Records found: ASPMX.L.GOOGLE.COM,ALT1.ASPMX.L.GOOGLE.COM,ALT2.ASPMX.L.GOOGLE.COM,ALT3.ASPMX.L.GOOGLE.COM,ALT4.ASPMX.L.GOOGLE.COM);
    x-return-mx=pass smtp.domain=linux-foundation.org policy.is_org=yes
      (MX Records found: ASPMX.L.GOOGLE.COM,ALT1.ASPMX.L.GOOGLE.COM,ALT2.ASPMX.L.GOOGLE.COM,ALT3.ASPMX.L.GOOGLE.COM,ALT4.ASPMX.L.GOOGLE.COM);
    x-tls=pass smtp.version=TLSv1.3 smtp.cipher=TLS_AES_256_GCM_SHA384
      smtp.bits=256/256;
    x-vs=clean score=40 state=0
X-ME-VSCause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtg
    hiphdvucdlgedtmdenucfjughrpeffhffvuffkjggfsedttdertddtredtnecuhfhrohhm
    peetnhgurhgvficuofhorhhtohhnuceorghkphhmsehlihhnuhigqdhfohhunhgurghtih
    honhdrohhrgheqnecuggftrfgrthhtvghrnhepjeevfeduveffvddvudetkefhgeduveeu
    geevvdfhhfevhfekkedtieefgfduheeinecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
    enucfkphepvddtledrkeehrddvudehrdduleekpdduleekrddugeehrddvledrleelnecu
    uegrugftvghpuhhtkfhppeduleekrddugeehrddvledrleelnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehinhgvthepvddtledrkeehrddvudehrdduleekpdhhvghl
    ohepmhgrihhlqdhpghduqdhfudelkedrghhoohhglhgvrdgtohhmpdhmrghilhhfrhhomh
    epoegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgqe
X-ME-VSScore: 40
X-ME-VSCategory: clean
X-ME-CSA: none
Received-SPF: pass
    (linux-foundation.org: Sender is authorized to use 'akpm@linux-foundation.org' in 'mfrom' identity (mechanism 'include:_spf.google.com' matched))
    receiver=mx6.messagingengine.com;
    identity=mailfrom;
    envelope-from="akpm@linux-foundation.org";
    helo=mail-pg1-f198.google.com;
    client-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx6.messagingengine.com (Postfix) with ESMTPS
	for <akpm@mbx.kernel.org>; Tue,  4 May 2021 23:16:31 -0400 (EDT)
Received: by mail-pg1-f198.google.com with SMTP id g5-20020a63f4050000b02901f6c7b9a6d0so593624pgi.5
        for <akpm@mbx.kernel.org>; Tue, 04 May 2021 20:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:dkim-signature:date:from:to:subject:message-id
         :in-reply-to:user-agent;
        bh=LuH7mbm3+zp863vKBEqKeoZtnpuFxYpIb5oTVwf56Es=;
        b=VZuDOxUfeHXJz1/CiFfcxuMVHkmW5RznvqYS+Py8Ub6nHHXprQJGE9Ze3WgH+1ylSe
         NJLEC7xgv15SR9A+e/MT4RTj3OVOwtd1Zi2vPav39a9K4tP+2uL2Ei+5d7FtT3LLZsjo
         feek/DqCGSkJ/EC5woLyU9BBkfLUuQ9/2HiDCk10BMetEfWdor69Slb39NOXES8br02X
         25Btabu9ZCWroyjQj7W5gwGr5Z6Hs2nbnnfAb+e92FalcUD/4ql77lNzRcWGi4/9TT8s
         ntqI2g46Xv+k5LURaRH5CRBpxkkKgzcrioRPYFUHkEgOEWy1hPzg9QPk8ZO35Xm9R9d2
         vl3Q==
X-Gm-Message-State: AOAM531IlYUTVWcMrsTunnxZWB7SKeeOmoZj5mZ1A5tl7N/JlZUueN8L
	tvyRKnvxHr6a5mDaGHN9Tb1N/iCzT0U5oQgRVTxTnj1qFGibRa9+leLQNKX0aGlNg9JiaMfromb
	xyOlCUpVXOlVvchuwTUSTn7rXum+Hh3PWQZm5II/EX+0AkzKqez62Z8U=
X-Received: by 2002:a17:90a:a581:: with SMTP id b1mr32203271pjq.53.1620184589161;
        Tue, 04 May 2021 20:16:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxffoGdRqAjUagWoMVD5p/Lk1KTEDftEhkWh8ewatgDmZLlxh0lO1hxYIdYYwoO5dsJ/i0z
X-Received: by 2002:a17:90a:a581:: with SMTP id b1mr32203198pjq.53.1620184588109;
        Tue, 04 May 2021 20:16:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1620184588; cv=none;
        d=google.com; s=arc-20160816;
        b=Fr2b2AMXJr6OeNpSql45tq1korkuDOunp7t+DpARuEBnwvQnKfagyipQ93jywsRf/c
         /i/mP2eTmJwOLWNORClh1MGF/0VfBx1ULoB9W4CI3LpVgGFXGGFis8LTcvUYD5yvhlsV
         50rm2j34iS9lyo04FB/hbhGkwLtUhz2PGkLGuqHspTd+pUpUCf5SLxGJbZC5uCcUEsbO
         8WSDBWyvaCPjFzJQZK60gK70ticKW+fCG1xHtOG4qsFCbqEpFKBy8eVK83OBazo/dQDr
         DOheWNWyw2o/WMP4GpZMvZuj30dx3j8xnBahIpnMIQJaog6wLMcVX9pkQ8UJym3/PGNm
         pO/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=user-agent:in-reply-to:message-id:subject:to:from:date
         :dkim-signature;
        bh=LuH7mbm3+zp863vKBEqKeoZtnpuFxYpIb5oTVwf56Es=;
        b=vVN16NPMKjoxSJQ6b36VXFCkZqnmG7wABfilgE069txZqmHpEMyZb8lRStkHy557LM
         Kn7UfJFP3xwsP8ZTCipVDZ6tpFW/hYFU9o4th9G8asWs+MOf9xpWX2LQZ1FTmaao2Fg5
         uCHypz39cnAh0Z1EJfNsTcaTGIrkbBd6zje+mtBgs8hnfH8HcWBYTPCHCCx950Z928tb
         XOPd/Igs7yzD1ioBiGXZj/ciwPbWVTaZXBg4JOZSApxkDMfuMyfyLLOs++EVkyxJHUme
         TmgwvLkixcwEtKF7gIeqEhwvOUSVvilLuJLFVaLumwTcjJ1amVfGcJhBE7LIM9C3SMpA
         rOOg==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@linux-foundation.org header.s=korg header.b="Gdz/3wY9";
       spf=pass (google.com: domain of akpm@linux-foundation.org designates 198.145.29.99 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from mail.kernel.org (mail.kernel.org. [198.145.29.99])
        by mx.google.com with ESMTPS id c85si20173199pfb.8.2021.05.04.20.16.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 May 2021 20:16:28 -0700 (PDT)
Received-SPF: pass (google.com: domain of akpm@linux-foundation.org designates 198.145.29.99 as permitted sender) client-ip=198.145.29.99;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@linux-foundation.org header.s=korg header.b="Gdz/3wY9";
       spf=pass (google.com: domain of akpm@linux-foundation.org designates 198.145.29.99 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4DB4610D2;
	Wed,  5 May 2021 03:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1620184587;
	bh=TxN4wgKcKf2UUem+5pL09m9GL/7U592mEalo2U6vwAU=;
	h=Date:From:To:Subject:In-Reply-To:From;
	b=Gdz/3wY9ktH3hOmn2DAOkfh0JXwPdMJ8xsNQFa9eI25K39Z3iHdRGo9jX3QtMDtog
	 D4Zakt52CQCYsV91c9oCai8KnCTkkAjJq/Ez7p8UHpz97Go3yYYxqg6DDl6d8HCQvN
	 H47dTaZAgeH2sw29bjB9fRzNuTx7k4RAPlqZIpiE=
Date: Tue, 04 May 2021 20:16:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, aou@eecs.berkeley.edu, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dalias@libc.org, deller@gmx.de, gor@linux.ibm.com, hca@linux.ibm.com, hpa@zytor.com, James.Bottomley@HansenPartnership.com, linux-mm@kvack.org, linux@armlinux.org.uk, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmerdabbelt@google.com, paul.walmsley@sifive.com, paulus@samba.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, viro@zeniv.linux.org.uk, will@kernel.org, ysato@users.osdn.me
Subject: [patch 103/143] mm: generalize SYS_SUPPORTS_HUGETLBFS (rename as ARCH_SUPPORTS_HUGETLBFS)
Message-ID: <20210505031626.c8o4WL7KE%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
X-Gm-Original-To: akpm@linux-foundation.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: generalize SYS_SUPPORTS_HUGETLBFS (rename as ARCH_SUPPORTS_HUGETLBFS)

SYS_SUPPORTS_HUGETLBFS config has duplicate definitions on platforms that
subscribe it.  Instead, just make it a generic option which can be
selected on applicable platforms.  Also rename it as
ARCH_SUPPORTS_HUGETLBFS instead.  This reduces code duplication and makes
it cleaner.

Link: https://lkml.kernel.org/r/1617259448-22529-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>	[riscv]
Acked-by: Michael Ellerman <mpe@ellerman.id.au>		[powerpc]
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                       |    5 +----
 arch/arm64/Kconfig                     |    4 +---
 arch/mips/Kconfig                      |    6 +-----
 arch/parisc/Kconfig                    |    5 +----
 arch/powerpc/Kconfig                   |    3 ---
 arch/powerpc/platforms/Kconfig.cputype |    6 +++---
 arch/riscv/Kconfig                     |    5 +----
 arch/sh/Kconfig                        |    5 +----
 fs/Kconfig                             |    5 ++++-
 9 files changed, 13 insertions(+), 31 deletions(-)

--- a/arch/arm64/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/arm64/Kconfig
@@ -73,6 +73,7 @@ config ARM64
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_USE_SYM_ANNOTATIONS
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_LTO_CLANG if CPU_LITTLE_ENDIAN
@@ -1072,9 +1073,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config SYS_SUPPORTS_HUGETLBFS
-	def_bool y
-
 config ARCH_HAS_FILTER_PGPROT
 	def_bool y
 
--- a/arch/arm/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/arm/Kconfig
@@ -31,6 +31,7 @@ config ARM
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT if CPU_V7
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_MEMTEST
@@ -1511,10 +1512,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config SYS_SUPPORTS_HUGETLBFS
-       def_bool y
-       depends on ARM_LPAE
-
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
        def_bool y
        depends on ARM_LPAE
--- a/arch/mips/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/mips/Kconfig
@@ -19,6 +19,7 @@ config MIPS
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
+	select ARCH_SUPPORTS_HUGETLBFS if CPU_SUPPORTS_HUGEPAGES
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_LD_ORPHAN_WARN
@@ -1287,11 +1288,6 @@ config SYS_SUPPORTS_BIG_ENDIAN
 config SYS_SUPPORTS_LITTLE_ENDIAN
 	bool
 
-config SYS_SUPPORTS_HUGETLBFS
-	bool
-	depends on CPU_SUPPORTS_HUGEPAGES
-	default y
-
 config MIPS_HUGE_TLB_SUPPORT
 	def_bool HUGETLB_PAGE || TRANSPARENT_HUGEPAGE
 
--- a/arch/parisc/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/parisc/Kconfig
@@ -12,6 +12,7 @@ config PARISC
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_NO_SG_CHAIN
+	select ARCH_SUPPORTS_HUGETLBFS if PA20
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select DMA_OPS
 	select RTC_CLASS
@@ -138,10 +139,6 @@ config PGTABLE_LEVELS
 	default 3 if 64BIT && PARISC_PAGE_SIZE_4KB
 	default 2
 
-config SYS_SUPPORTS_HUGETLBFS
-	def_bool y if PA20
-
-
 menu "Processor type and features"
 
 choice
--- a/arch/powerpc/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/powerpc/Kconfig
@@ -697,9 +697,6 @@ config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 	depends on PPC_BOOK3S_64
 
-config SYS_SUPPORTS_HUGETLBFS
-	bool
-
 config ILLEGAL_POINTER_VALUE
 	hex
 	# This is roughly half way between the top of user space and the bottom
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -40,8 +40,8 @@ config PPC_85xx
 
 config PPC_8xx
 	bool "Freescale 8xx"
+	select ARCH_SUPPORTS_HUGETLBFS
 	select FSL_SOC
-	select SYS_SUPPORTS_HUGETLBFS
 	select PPC_HAVE_KUEP
 	select PPC_HAVE_KUAP
 	select HAVE_ARCH_VMAP_STACK
@@ -95,9 +95,9 @@ config PPC_BOOK3S_64
 	bool "Server processors"
 	select PPC_FPU
 	select PPC_HAVE_PMU_SUPPORT
-	select SYS_SUPPORTS_HUGETLBFS
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select IRQ_WORK
 	select PPC_MM_SLICES
@@ -278,9 +278,9 @@ config FSL_BOOKE
 # this is for common code between PPC32 & PPC64 FSL BOOKE
 config PPC_FSL_BOOK3E
 	bool
+	select ARCH_SUPPORTS_HUGETLBFS if PHYS_64BIT || PPC64
 	select FSL_EMB_PERFMON
 	select PPC_SMP_MUXED_IPI
-	select SYS_SUPPORTS_HUGETLBFS if PHYS_64BIT || PPC64
 	select PPC_DOORBELL
 	default y if FSL_BOOKE
 
--- a/arch/riscv/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/riscv/Kconfig
@@ -30,6 +30,7 @@ config RISCV
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
+	select ARCH_SUPPORTS_HUGETLBFS if MMU
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
@@ -165,10 +166,6 @@ config ARCH_WANT_GENERAL_HUGETLB
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
-config SYS_SUPPORTS_HUGETLBFS
-	depends on MMU
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
--- a/arch/sh/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/sh/Kconfig
@@ -101,9 +101,6 @@ config SYS_SUPPORTS_APM_EMULATION
 	bool
 	select ARCH_SUSPEND_POSSIBLE
 
-config SYS_SUPPORTS_HUGETLBFS
-	bool
-
 config SYS_SUPPORTS_SMP
 	bool
 
@@ -175,12 +172,12 @@ config CPU_SH3
 
 config CPU_SH4
 	bool
+	select ARCH_SUPPORTS_HUGETLBFS if MMU
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
 	select CPU_HAS_FPU if !CPU_SH4AL_DSP
 	select SH_INTC
 	select SYS_SUPPORTS_SH_TMU
-	select SYS_SUPPORTS_HUGETLBFS if MMU
 
 config CPU_SH4A
 	bool
--- a/fs/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/fs/Kconfig
@@ -223,10 +223,13 @@ config TMPFS_INODE64
 
 	  If unsure, say N.
 
+config ARCH_SUPPORTS_HUGETLBFS
+	def_bool n
+
 config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || SPARC64 || (S390 && 64BIT) || \
-		   SYS_SUPPORTS_HUGETLBFS || BROKEN
+		   ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
 	  ramfs. For architectures that support it, say Y here and read
_

--Multipart=_Wed__5_May_2021_10_44_01_-0700_LsVOFQr+Xs5/FBnR--
