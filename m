Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95568C07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 09:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C786136E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 09:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhGOJiG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 05:38:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52376 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhGOJiG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jul 2021 05:38:06 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9D2C22292A;
        Thu, 15 Jul 2021 09:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626341712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/4CQgC1slhvxkRd4LR3wgf3PplGpEUBrClmRaNbPx4=;
        b=VWLIPqovfo7Z94YK56MvIymH3XnZSV+6vfC54zkN2nQpEQEKQZdDQ7KPBqjHAQN4GO7b3V
        DrOE7q7JUXOoo6u92iJc2wRTNVascv08OGdyvEQCZX9hv0nnTeYY64jKKRd7+BsCI5qpB2
        I2lqNPoFtVn+d0p+WjpyBKe1XOHCFGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626341712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/4CQgC1slhvxkRd4LR3wgf3PplGpEUBrClmRaNbPx4=;
        b=cp+9VhQbUBJ8GaBFWnV6IkbbVOS+NqzwFBw0kLhH7kt+rubdxNT/RxCC09uWdIB2hqIc/B
        xOaW0oo5avVvbeAQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6FA2613AB3;
        Thu, 15 Jul 2021 09:35:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id PnUMG1AB8GDPCAAAGKfGzw
        (envelope-from <osalvador@suse.de>); Thu, 15 Jul 2021 09:35:12 +0000
MIME-Version: 1.0
Date:   Thu, 15 Jul 2021 11:35:12 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     akpm@linux-foundation.org
Cc:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        anton@ozlabs.org, ardb@kernel.org, bauerman@linux.ibm.com,
        benh@kernel.crashing.org, bhe@redhat.com, borntraeger@de.ibm.com,
        bp@alien8.de, catalin.marinas@arm.com, cheloha@linux.ibm.com,
        christophe.leroy@c-s.fr, dalias@libc.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hpa@zytor.com, jasowang@redhat.com, joe@perches.com,
        justin.he@arm.com, ldufour@linux.ibm.com, lenb@kernel.org,
        luto@kernel.org, mhocko@kernel.org, michel@lespinasse.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        mst@redhat.com, nathanl@linux.ibm.com, npiggin@gmail.com,
        pankaj.gupta.linux@gmail.com, pankaj.gupta@ionos.com,
        pasha.tatashin@soleen.com, paulus@samba.org, peterz@infradead.org,
        pmorel@linux.ibm.com, rafael.j.wysocki@intel.com,
        richard.weiyang@linux.alibaba.com, rjw@rjwysocki.net,
        rppt@kernel.org, slyfox@gentoo.org, tglx@linutronix.de,
        vbabka@suse.cz, vishal.l.verma@intel.com, vkuznets@redhat.com,
        wangkefeng.wang@huawei.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject: Re: + acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
 added to -mm tree
In-Reply-To: <20210714234454.uDqO8_L5c%akpm@linux-foundation.org>
References: <20210714234454.uDqO8_L5c%akpm@linux-foundation.org>
User-Agent: Roundcube Webmail
Message-ID: <59eed031cdeaf5563bb3ab49b3fa5d7f@suse.de>
X-Sender: osalvador@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


> ------------------------------------------------------
> From: David Hildenbrand <david@redhat.com>
> Subject: ACPI: memhotplug: memory resources cannot be enabled yet
> 
> We allocate + initialize everything from scratch.  In case enabling the
> device fails, we free all memory resourcs.
> 
> Link: https://lkml.kernel.org/r/20210712124052.26491-5-david@redhat.com
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Anton Blanchard <anton@ozlabs.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Jia He <justin.he@arm.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michel Lespinasse <michel@lespinasse.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Nathan Lynch <nathanl@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pankaj Gupta <pankaj.gupta@ionos.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Scott Cheloha <cheloha@linux.ibm.com>
> Cc: Sergei Trofimovich <slyfox@gentoo.org>
> Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3
