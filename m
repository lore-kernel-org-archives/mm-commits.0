Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF251ECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 18:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiJ0S4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 14:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbiJ0S4k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 14:56:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445FA51A06
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 11:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42AE5B82777
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 18:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B3BC433D6;
        Thu, 27 Oct 2022 18:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666896994;
        bh=dQWdJMu698nsi2B6BnKLJ3aj7pbZOv6fNC7Gbyjfyh4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dPYWskQxcD1SCtLL7M9Ip8IgcgQ/jglNVj194nE5HyWThiRMvgzd+Gi4SJdJc2/BD
         lhjnyEghYkzT3lx9CfTqMM0GHi79Ua4inPaPM4+TCgbJE0QtqMyXH1DHn0fHq72OTj
         /ePtL3hJFqBanzzjzri3XHYIyU+Px/y43SQEfZg0=
Date:   Thu, 27 Oct 2022 11:56:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Felix Kuehling <felix.kuehling@amd.com>
Cc:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, kherbst@redhat.com,
        jhubbard@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        jack@suse.cz, hch@lst.de, djwong@kernel.org, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, Yang Li <yang.lee@linux.alibaba.com>
Subject: Re: +
 mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch added
 to mm-unstable branch
Message-Id: <20221027115632.aa8bd33027ecea77a30f7674@linux-foundation.org>
In-Reply-To: <3a35bcc0-71df-c302-081d-990c5e5ed096@amd.com>
References: <20221021192639.3FDBBC433C1@smtp.kernel.org>
        <3a35bcc0-71df-c302-081d-990c5e5ed096@amd.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 26 Oct 2022 16:23:22 -0400 Felix Kuehling <felix.kuehling@amd.com> wrote:

> > --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
> > +++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> [snip]
> > @@ -325,7 +328,8 @@ svm_migrate_copy_to_vram(struct amdgpu_d
> >   
> >   		dst[i] = cursor.start + (j << PAGE_SHIFT);
> >   		migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
> > -		svm_migrate_get_vram_page(prange, migrate->dst[i]);
> > +			svm_migrate_get_vram_page(&kfddev->pgmap, prange,
> > +						  migrate->dst[i]);
> 
> Yang Lee pointed out that the indentation was broken here. I don't know 
> what to do with his patch because it doesn't apply to the branches I 
> work on. What's the best way to fix this before it goes to Linus' master 
> branch?

Thanks, I added a fixup patch.
