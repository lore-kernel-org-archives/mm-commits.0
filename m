Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DAAC7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 23:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjFAXCq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 19:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjFAXCq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 19:02:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC430199
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 16:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5726D64A14
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 23:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5EEC433EF;
        Thu,  1 Jun 2023 23:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685660562;
        bh=iNa72y1ZjSeSaIPl1VYp4bx0Y5yw/D5aCHhBCKxjsfU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tVY9FXNulQsPfSFA7I+WW/Q3ZvK+rjOgwCQeE+rGQ8zTheHpa8iIxzM/ETn2v9KjK
         cHXk5zs8CgHD3TzKn6MNM8Qe3NYG/E+UkRhPdaLEzhxnfWtXSTp8jktJvUp9sYejOD
         PzCpfAZgMYF5Au1gjwXHGW7aL0iwm2djbv985NWo=
Date:   Thu, 1 Jun 2023 16:02:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        tim.gardner@canonical.com, thomas.lendacky@amd.com,
        tglx@linutronix.de, seanjc@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, rppt@linux.ibm.com,
        rientjes@google.com, peterz@infradead.org, peterx@redhat.com,
        pbonzini@redhat.com, mingo@redhat.com, mgorman@techsingularity.net,
        marcelo.cerri@canonical.com, luto@kernel.org,
        liam.merwick@oracle.com, jroedel@suse.de, dfaggioli@suse.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, bp@suse.de, ardb@kernel.org,
        ak@linux.intel.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com
Subject: Re: + x86-boot-compressed-handle-unaccepted-memory.patch added to
 mm-unstable branch
Message-Id: <20230601160240.ed87426e1334f649d7075bf6@linux-foundation.org>
In-Reply-To: <20230601220410.GGZHkV2juLtRq4uaJw@fat_crate.local>
References: <20230601214841.55DFAC433EF@smtp.kernel.org>
        <20230601220410.GGZHkV2juLtRq4uaJw@fat_crate.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 2 Jun 2023 00:04:10 +0200 Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Jun 01, 2023 at 02:48:40PM -0700, Andrew Morton wrote:
> >  arch/x86/boot/compressed/efi.h   |   10 ++++++++
> >  arch/x86/boot/compressed/kaslr.c |   35 +++++++++++++++++++----------
> >  arch/x86/boot/compressed/mem.c   |   31 +++++++++++++++++++++++++
> >  arch/x86/boot/compressed/misc.c  |    7 +++++
> >  arch/x86/boot/compressed/misc.h  |    6 ++++
> >  5 files changed, 77 insertions(+), 12 deletions(-)
> 
> Andrew, please drop at least the x86 bits from your tree.
> 
> There's other TDX stuff which would conflict with this in tip and, more
> importantly, the AMD side of unaccepted memory needs to go in together:
> 
> https://lore.kernel.org/r/cover.1684513813.git.thomas.lendacky@amd.com
> 
> If you wanna pick up the mm bits and give us an immutable branch which
> we can merge, that would be ok. But please don't take x86 bits through
> your tree.

OK, I dropped the whole series from mm-unstable.
