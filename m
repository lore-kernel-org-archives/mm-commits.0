Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF8EC6FA8E
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 20:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjBXURT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 15:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjBXURL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 15:17:11 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB375EEFA
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 12:17:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s26so1798036edw.11
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 12:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oIjZaVoTVRiYI2EI9MNfmYEqGX+2eYmslPvrV4hb04Y=;
        b=PNmzsJlYLy+1uKOxvOEqIIXYgWt88eDr+EceyU7mtzyAvlN5COX5huKkWnRJM3He38
         SLW8PKiw6XnfBYKZ6DNhjirmDKps4/6eUrx3gFw/GVsGHfzH3B+BLCA2pQ0TWezNZPOv
         spT1BQ0QU4eREUNc1HOHpnJ4apcNtTyrTrOCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oIjZaVoTVRiYI2EI9MNfmYEqGX+2eYmslPvrV4hb04Y=;
        b=lbWwrPI6NH3RPk/46uUhHZFdJxa/K4VpVwjgpfwNMKpd61FxLOpIjDSs/Ptg6F9zVQ
         h0aT1kmk2g4lVY+CnLIFvUadlaT267HuQx6UNGUS05mUlBYNxUqnC/64FohvpVPLfXUf
         O06dgmJIuw/WcEaVHLMLXkC+wPTtMZZBetlAXR5txf8eGVxveXMq61/WATCzIq9ByeaG
         WAkh0wRSiEpfYpmZD2paeBBFYlVHvXo6eZZW6Zr5TcsMnn6Qt05fvWwZDdthHayqD+qF
         kYiLOVsEtHE4P37S3o2G7ZNIWq6Qm+cu5cW5T3vcyY0KD7/BvXOBPRhpmIE2EJWMx1yj
         pGNQ==
X-Gm-Message-State: AO0yUKUFpB6RYH5wjc/eDv1wfpdodCDSVMOStxFSTbGtdI2Ia0GUrbZF
        lGLKviYl9TxXFhSQC0fZgxNogwmNfjm3jSal8OBN9A==
X-Google-Smtp-Source: AK7set/UGFMzwUQkOnQj5eMr1kvsIRcRXDeIiJq6dXOyv5XjoIhBXW0IKmV0FoyZaOp/BNc9VSzy0g==
X-Received: by 2002:aa7:df15:0:b0:4ae:f496:ee2 with SMTP id c21-20020aa7df15000000b004aef4960ee2mr14462932edy.20.1677269827801;
        Fri, 24 Feb 2023 12:17:07 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id c30-20020a50d65e000000b004acbe5409b4sm110639edj.48.2023.02.24.12.17.06
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 12:17:07 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id cq23so2019869edb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 12:17:06 -0800 (PST)
X-Received: by 2002:a17:907:988c:b0:877:747e:f076 with SMTP id
 ja12-20020a170907988c00b00877747ef076mr11089353ejc.0.1677269826565; Fri, 24
 Feb 2023 12:17:06 -0800 (PST)
MIME-Version: 1.0
References: <Y/jhwuTCaOgOTLp2@casper.infradead.org> <2134430.1677240738@warthog.procyon.org.uk>
 <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
 <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <2213409.1677249075@warthog.procyon.org.uk> <2385089.1677258941@warthog.procyon.org.uk>
 <Y/kFnhUM5hjWM2Ae@casper.infradead.org> <2390711.1677269637@warthog.procyon.org.uk>
In-Reply-To: <2390711.1677269637@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 12:16:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgpjrdcs_aFvdHdH6TpOsOmN9S5rXDqCZTB8WqXsZH8Qw@mail.gmail.com>
Message-ID: <CAHk-=wgpjrdcs_aFvdHdH6TpOsOmN9S5rXDqCZTB8WqXsZH8Qw@mail.gmail.com>
Subject: Re: [RFC][PATCH] cifs: Fix cifs_writepages_region()
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Steve French <stfrench@microsoft.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@cjr.nz>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Feb 24, 2023 at 12:14 PM David Howells <dhowells@redhat.com> wrote:
>
> Then why do we have to wait for PG_writeback to complete?

At least for PG_writeback, it's about "the _previous_ dirty write is
still under way, but - since PG_dirty is set again - the page has been
dirtied since".

So we have to start _another_ writeback, because while the current
writeback *might* have written the updated data, that is not at all
certain or clear.

I'm not sure what the fscache rules are.

                Linus
