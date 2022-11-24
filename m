Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3649C47088
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 07:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiKXHM3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 02:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiKXHMQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 02:12:16 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42509CFEBD
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 23:17:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C715E21875;
        Thu, 24 Nov 2022 07:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669274231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fQjnc8+CSF/9rTNLbP49osYtDw6PRWRcrBw+Y8RBBcY=;
        b=kHNItKoBgprPj0eUslIqErAIsKFgoQSYIi+S1LeR+CU+g7D3kfWo1SCj+e/IR+sJROBAru
        md2SYg4/cxnjnOn//LQVKCYvQXB5A6a03BTxtm4OfU0IrL7s/Yt4stev1rip3VTsy7DLMt
        fpSIqVS88lpZpCdW63IgoyguJpk1CfU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A78C213A21;
        Thu, 24 Nov 2022 07:17:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hKAmJncaf2PvRwAAMHmgww
        (envelope-from <mhocko@suse.com>); Thu, 24 Nov 2022 07:17:11 +0000
Date:   Thu, 24 Nov 2022 08:17:10 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, zokeefe@google.com, shy828301@gmail.com
Subject: Re: +
 mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch
 added to mm-hotfixes-unstable branch
Message-ID: <Y38adlO8/Gky/3Z5@dhcp22.suse.cz>
References: <20221123195755.F2521C433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123195755.F2521C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed 23-11-22 11:57:55, Andrew Morton wrote:
[...]
> -static inline void warn_if_node_offline(int nid, gfp_t gfp_mask)
> +static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
>  {
> -	gfp_t gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
> +	gfp_t warn_gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
>  
> -	if ((gfp == (__GFP_THISNODE|__GFP_NOWARN)) && !node_online(nid)) {
> -		pr_warn("%pGg allocation from offline node %d\n", &gfp, nid);
> -		dump_stack();
> -	}
> +	if (warn_gfp != (__GFP_THISNODE|__GFP_NOWARN))
> +		return;
> +
> +	if(node_online(this_node))
> +		return;
> +
> +	pr_warn("%pGg allocation from offline node %d\n", &warn_gfp, this_node);

This should be gfp_mask printed, not the filtered part of it.

> +	dump_stack();
>  }
>  
>  /*
> _
> 
> Patches currently in -mm which might be from shy828301@gmail.com are
> 
> mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch
> mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch

-- 
Michal Hocko
SUSE Labs
