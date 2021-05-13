Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD5BC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 10:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E4C66142C
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 10:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhEMKeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 06:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhEMKeP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 May 2021 06:34:15 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12358C061574
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 03:33:03 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id r5so20676254lfr.5
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 03:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sa/qR2RVGlb5BAx6kvThWIABJDyI4ZxnTMwTzwW78ik=;
        b=hKv6a/ZqMRXXaHdg+wvGg3HeRLNzODvhHh0ym+8QTRy7TD5y+8jpkEbvASuhxd2kuq
         Z4izTusbHhqIc5ksZgNDJ2hwMAmZrIQDxBa6SNscQyrdHTF9mYv/PgR+2lxMjEiou3HZ
         7+88G70/lYptXbuo+B6Ah/0jiImKnU54L6EF0jDZJ19foB29dZ8qnsqg/sjS4d7VEQ3M
         mjKQjmDoCgKqaTtYxVoRuclW4dY6B4jqmHgPcCmOlzncfWsqr36YPk+1UrYp8VIJkiLq
         tQiF+3F/4OCrEeapwBSw6r07KAHGhaGqcNRnbTvUlG9ovuIJGyY03RqNzQWnkR7SzfZC
         z4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sa/qR2RVGlb5BAx6kvThWIABJDyI4ZxnTMwTzwW78ik=;
        b=BJXd3MszGtdtmTE1v/FY31YabeXqjZntil9xD46WGLRvqWIn2MvcghqN6CHx6TeX66
         3vrNEAheuh/jORWr+Naomwa4hlGutUL9C2LfEDksabUYaGnbwyIsTrD/74UAXKxJhx9h
         Z5Cfcq0dil1xJFas+fK+pzInGm22krLQa2f4ZBu2Ptf47b5gKKHaiYTXEnMqaZYisWNH
         Esoa0Mqs0pswnKpv6dbl7MBaMsm+0h9DQHdmpPWf1/PieQM25jVosowWKQlJdTGcNsRB
         HHOcxwIdRRT7gbrn9d6mHYMqhMpbPScsyWMgpv/doeMUlm2grliR90kE5UvmLWMOpgo5
         jNpg==
X-Gm-Message-State: AOAM532oaNRJ6Czzu2rUF9Jo4r6D7InE37jpVrsN8AbUzkhhbFyYOvwe
        GryEMIUUiFykSKIX/LPYKVU=
X-Google-Smtp-Source: ABdhPJzMA4dsVqAc0PJkcTLcyGn5Oobt6PGDeyVRpcNsdlJ2T8e/uyXwOt2yfD/I8SBazjggoJjBKQ==
X-Received: by 2002:ac2:5fcb:: with SMTP id q11mr27961407lfg.248.1620901981606;
        Thu, 13 May 2021 03:33:01 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id j16sm249283lfe.152.2021.05.13.03.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 03:33:01 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 13 May 2021 12:32:59 +0200
To:     Stephen Rothwell <sfr@canb.auug.org.au>, akpm@linux-foundation.org
Cc:     akpm@linux-foundation.org, hdanton@sina.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject: Re: [failures]
 mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch removed
 from -mm tree
Message-ID: <20210513103259.GB1856@pc638.lan>
References: <20210512202949.eUYaWpNcg%akpm@linux-foundation.org>
 <20210513085524.71ae6900@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513085524.71ae6900@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 13, 2021 at 08:55:24AM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> On Wed, 12 May 2021 13:29:49 -0700 akpm@linux-foundation.org wrote:
> >
> > The patch titled
> >      Subject: mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()
> > has been removed from the -mm tree.  Its filename was
> >      mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch
> > 
> > This patch was dropped because it had testing failures
> 
> Removed from linux-next.
> 
What can of testing failures does it trigger? Where can i find the
details, logs or tracers of it?

Thanks.

--
Vlad Rezki
