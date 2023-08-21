Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D1AEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 01:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjHUBLO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 20 Aug 2023 21:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjHUBLN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 20 Aug 2023 21:11:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115E999
        for <mm-commits@vger.kernel.org>; Sun, 20 Aug 2023 18:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692580225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4im+PpzefIsfnwu5OPywWrY52m5M1sOdAntmf92wGqk=;
        b=bMHHm0THFb1cN8zVKzjcSO38fhq+M8vyxsXyUlRsBbbAFS9j36koumUmULcsRBdt73nG7z
        zdcQriBP/LQVgXN+RjTALg6Ot6/9u2DlhLq8VmYgmZ6RNgYflXG+KTta1wWqY9X7UupijB
        KWbjUYT1lwBZ4G2S9zmuNJguTl+KOn4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-dh0Hp1yQOk6XQOLm16wzWg-1; Sun, 20 Aug 2023 21:10:23 -0400
X-MC-Unique: dh0Hp1yQOk6XQOLm16wzWg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-76c7cffef41so99684885a.1
        for <mm-commits@vger.kernel.org>; Sun, 20 Aug 2023 18:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692580222; x=1693185022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4im+PpzefIsfnwu5OPywWrY52m5M1sOdAntmf92wGqk=;
        b=T1/HH6BqP1OHjum8MhC/s8tBPO/VpV6g3n4UAp36XZ6nwyVzXkPbsWcTMpNUXwZp4G
         xjyFNGuLjljNuxA5RsOcfT2WNGte/OPn6YKbd0bG58s6bj42YzO8/ZoSVrF+SkAQOPDx
         HQYN+DNe73uBQ0zWGmPmYRDz9wOvGMezdi2oCobsXjhFg66A0NcBwEn5OJFJiTwGuKyB
         29v2bK2euvvPfUbYZ7xkl4cP4SoJks3rb5W3RPui2UOP80YuVllgrPi1A8mkjvS06gVH
         11gpnWnVIsrUftzBvnMFnXSMlm1KEUKITBYfIIDVGEegPSSxCkZxLBZ6/UhfrD5UqkHv
         e8BA==
X-Gm-Message-State: AOJu0YykAqRZkxwGHiNHLvZCNrHU6qp27v1WVSRQqUORNaCh6wwJTmpU
        Vf7ZrFilc15zsfSv/S5wITgqaI0j7tSi7prcIGThk+qu6hIBU/QGACxtBRubwTW+2W3K6qCNsBX
        g2Ar2Leaau+2QWzQtQkxpHA==
X-Received: by 2002:a05:620a:17a0:b0:76c:ed4e:ac10 with SMTP id ay32-20020a05620a17a000b0076ced4eac10mr8073054qkb.6.1692580222703;
        Sun, 20 Aug 2023 18:10:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGepQJBfqiDTgXDbAZewPwFjMzJuyba2D9xZFkDDqU4DejhoOgFR5I+yhhaeVmWJ4n+cLBd4g==
X-Received: by 2002:a05:620a:17a0:b0:76c:ed4e:ac10 with SMTP id ay32-20020a05620a17a000b0076ced4eac10mr8073033qkb.6.1692580222451;
        Sun, 20 Aug 2023 18:10:22 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id r5-20020a05620a03c500b0076730d0b0b9sm2131454qkm.14.2023.08.20.18.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Aug 2023 18:10:21 -0700 (PDT)
Date:   Sun, 20 Aug 2023 21:10:20 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, hughd@google.com,
        david@redhat.com
Subject: Re: + mm-wire-up-tail-page-poisoning-over-mappings.patch added to
 mm-unstable branch
Message-ID: <ZOK5fCHC2K+c7a1d@x1n>
References: <20230818200031.BC269C433C9@smtp.kernel.org>
 <ZN/Uvq1qtlmK25e5@casper.infradead.org>
 <20230818140214.33027519d09c55f8f2221479@linux-foundation.org>
 <ZN/tgtMhuSFDFD6a@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZN/tgtMhuSFDFD6a@casper.infradead.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Aug 18, 2023 at 11:15:30PM +0100, Matthew Wilcox wrote:
> On Fri, Aug 18, 2023 at 02:02:14PM -0700, Andrew Morton wrote:
> > On Fri, 18 Aug 2023 21:29:50 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> > 
> > > On Fri, Aug 18, 2023 at 01:00:30PM -0700, Andrew Morton wrote:
> > > > From: Peter Xu <peterx@redhat.com>
> > > > Subject: mm: wire up tail page poisoning over ->mappings
> > > > Date: Tue, 15 Aug 2023 17:06:59 -0400
> > > 
> > > Did I need to keep NAKing this patch, or did you disagree with my NAK?
> > 
> > This is the first time this patch has been sent out (under this title)
> > and it sat on the lists unreplied-to for three days.
> 
> He didn't address my objection to the earlier one.
> 
> https://lore.kernel.org/linux-mm/ZNp7yUgUrIpILnXu@casper.infradead.org/

I replied.

https://lore.kernel.org/linux-mm/ZNqFv0AwkfDKExiw@x1n/

> 
> Anyway, I've replied to it now in *that* thread.

This patch should be straightforward to me, I really don't understand your
point.

I can reply to you again there, of course.  Let me try.

-- 
Peter Xu

