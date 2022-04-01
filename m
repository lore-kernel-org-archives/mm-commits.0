Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77A7C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 17:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349408AbiDARGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 13:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237726AbiDARGN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 13:06:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7E217664D;
        Fri,  1 Apr 2022 10:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 135D7B82541;
        Fri,  1 Apr 2022 17:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F259C340EC;
        Fri,  1 Apr 2022 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648832659;
        bh=94IkdATbKxje4+sxqvNfbQStcJatrQRJocYEl0M2EKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CXWaNTM5sZQ7PSbbWDxL7RVH5QVtB18fM8RW/BAMwzje1S4b7ynAQiA2gfsupm/cG
         coJDXjItJjhU6i+ygli0rOr9AEo8UOUp6oIFMBefXhEpPL/e+5vkg3IoQaJhTOGRGd
         JTIpgQ0f8Aof8MrLPAKy85r07lHJRWuJYMmo/e3zQvZWpurnXbg238RmxTSkv+3hxT
         W1nWB1lI0j8JBkb58I74kFe8oR3su9dFPdf2O5Wpc0g+My6AMmgFb7GkrSCIyt0qf6
         yMesR5aQsFHmR9SUonrUYGnaLdieHNLpA7UfwKpJxnQOjKvptIg0osFEZHhxfWdTfs
         pUEsU8TbX5pQg==
Date:   Fri, 1 Apr 2022 10:04:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Dimitris Michailidis <dmichail@fungible.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        mhocko@suse.cz, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: mmotm 2022-03-31-20-37 uploaded
 (drivers/net/ethernet/fungible/funcore/fun_dev.o)
Message-ID: <20220401100418.7c109f81@kernel.org>
In-Reply-To: <048945eb-dd6b-c1b6-1430-973f70b4dda5@infradead.org>
References: <20220401033845.8359AC2BBE4@smtp.kernel.org>
        <048945eb-dd6b-c1b6-1430-973f70b4dda5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 31 Mar 2022 22:15:15 -0700 Randy Dunlap wrote:
> On 3/31/22 20:38, Andrew Morton wrote:
> > The mm-of-the-moment snapshot 2022-03-31-20-37 has been uploaded to
> > 
> >    https://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > https://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> > You will need quilt to apply these patches to the latest Linus release (5.x
> > or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > https://ozlabs.org/~akpm/mmotm/series
> 
> on i386:
> 
> ld: drivers/net/ethernet/fungible/funcore/fun_dev.o: in function `fun_dev_enable':
> (.text+0xe1a): undefined reference to `__udivdi3'

Doesn't fail here.

Oh... Probably this:

        num_dbs = (pci_resource_len(pdev, 0) - NVME_REG_DBS) /                  
                  (fdev->db_stride * 4);      

The bad config must have 64b resource length. Dimitris, PTAL.
