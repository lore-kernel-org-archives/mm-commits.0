Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD7BC04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 03:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiG1DeM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jul 2022 23:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiG1DeL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2022 23:34:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99F65A2D7
        for <mm-commits@vger.kernel.org>; Wed, 27 Jul 2022 20:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8541CB82315
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 03:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CF9C433C1;
        Thu, 28 Jul 2022 03:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658979247;
        bh=6GpGEa+AM+qYKnsIForRxq0tfBd18h1VEsWNKHJfP/I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jhhiWbzmtyqQEISOQerDyBPm7w5holPhzn4aCAaPUr5sqk1Hrb8gb3FmGsgoU7rhN
         htHeXXWzaSSVVIR/fslvnfKnV2TgHPZUJDHbTnxUZM3aIpehewKd8urdMl2agaoDB4
         +5Id5W6rEtiKSveyI3+2+3IpQ7B0auh2hxVB0iok=
Date:   Wed, 27 Jul 2022 20:34:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     mm-commits@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: + mm-delete-unused-mmf_oom_victim-flag.patch added to
 mm-unstable branch
Message-Id: <20220727203405.aa0908390d905b1671772c0e@linux-foundation.org>
In-Reply-To: <CAJuCfpE3V6LzL+XW2mzLm-h1f9KVurp8v_cKNstR+dqmw1MYNw@mail.gmail.com>
References: <20220601213751.9305CC385A5@smtp.kernel.org>
        <CAJuCfpE3V6LzL+XW2mzLm-h1f9KVurp8v_cKNstR+dqmw1MYNw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 27 Jul 2022 11:17:20 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> > The patch titled
> >      Subject: mm: delete unused MMF_OOM_VICTIM flag
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-delete-unused-mmf_oom_victim-flag.patch
> 
> I can't find this and the accompanying patch
> (https://lore.kernel.org/all/20220601213748.DAF1DC385A5@smtp.kernel.org/
> and https://lore.kernel.org/all/20220601213751.9305CC385A5@smtp.kernel.org/)
> in any tree now and can't find any notifications about them being
> dropped. Could you please check what happened to them? I remember
> there was a minor conflict with maple-tree patchset that we resolved,
> so maybe they are queued together?

Yesterday I removed the mapletree patchset from mm-unstable, as it
isn't suitable for the next merge window.

Three other series were significantly dependent on mapletree:

	Refactor of vma_merge and new merge call

	mm: drop oom code from exit_mmap
	mm: delete unused MMF_OOM_VICTIM flag

	Refactor of vma_merge and new merge call

and the single patch

	mm/mlock: drop dead code in count_mm_mlocked_page_nr()

None of these are very urgent and I might hold them over until
mapletree is reintroduced.  This is the lowest risk approach.

I need to revisit these patches to see if they can be reworked for a 5.20-rc1
with acceptable risk at this late stage.


