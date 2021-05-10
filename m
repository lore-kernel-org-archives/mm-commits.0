Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216D0C43460
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 12:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E77CE61432
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 12:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhEJM1Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 08:27:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238526AbhEJLqZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 07:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620647119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wrnGfWAQo+AfggW4TAXOXcPiZDtGK94s7LE3HMGzzZA=;
        b=LyHZ+uZiMz3z4lbbMg63IZk77PVzhtNN+rJpDLAOLWl5Hb5teRcqxmRTyJcBLEz27bs0OB
        TLqhvfmQWgGC/fcoYNz75WVqNBPSzAggkORohJ0ospN+FoZhkGzuoKeUb20v0XLBWnMvW7
        pioWQ9RqvaH9vZSMpAhyqlsJ15/WJMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-ml_NmExAPqub_pU6sVFq8w-1; Mon, 10 May 2021 07:45:15 -0400
X-MC-Unique: ml_NmExAPqub_pU6sVFq8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C991364157;
        Mon, 10 May 2021 11:45:10 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3C125D9CA;
        Mon, 10 May 2021 11:44:54 +0000 (UTC)
Date:   Mon, 10 May 2021 19:44:50 +0800
From:   Dave Young <dyoung@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Baoquan He <bhe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        andreyknvl@google.com, christian.brauner@ubuntu.com,
        colin.king@canonical.com, corbet@lwn.net, frederic@kernel.org,
        gpiccoli@canonical.com, john.p.donnelly@oracle.com,
        jpoimboe@redhat.com, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mike.kravetz@oracle.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        yifeifz2@illinois.edu, Michal Hocko <mhocko@kernel.org>
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
 <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi David,
On 05/10/21 at 01:01pm, David Hildenbrand wrote:
[snip]
> It also bugged me for quite a bit that we don't have a sane way to achieve
> what we're doing here upstream. It somewhat feels like "this doesn't belong
> in the kernel and is user policy" but then, the existing kernel support is
> suboptimal.
> 
> Maybe reserving some "maybe too big but okayish to boot the system in a sane
> environment -- e.g., X% of system RAM and at least Y" size first and
> shrinking it later as triggered by user space early (where we do seem to
> have a way to pre-calculate things now) might actually be a good direction
> to look into.

Hmm, that is also an option we considered before.  Even for your
suggestion we still need a kernel option to set the default ratio/value.
and the ratio/value should be another patch which expands crashkernel
syntax.

Actually the kconfig help text in this patch is indeed misleading, it is
not introducing crashkernel=a:b... and no need to explain about the
crashkernel syntax, the config option is actually just some interface we
can add any valid crashkernel settings to be used by default. So current
patch help text describes the default value of crash auto str, instead
of describes what crash auto str is. 

And crashkernel=auto makes this more flexibly. We can tune the values
easily when upgrading.  But if we pass a fixed value in userspace we
can not know if the value is set by distribution automatically or by user
manually thus we can not blindly update it.

Thanks
Dave

