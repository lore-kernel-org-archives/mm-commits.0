Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D2DC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 03:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E2B06144F
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 03:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhEHDOX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 May 2021 23:14:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhEHDOX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2021 23:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620443602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cB3YJ/UTXstMRO1/fjDoVD+wrGPYTF2eUjYxuu8oqMI=;
        b=LeTn5qd5R5SFbeYK2HY6luGc6GnocKIwshS2NjYg4bu+iFUd32XRlf5RznjsN/l5CJseNF
        2gOKZRv8MWW6rY9ze7ONvJ4J7dxopqpkWblVlbIcugg/8Ll7WejlSe6aHf4FbNQVJqFCxD
        Zt541/8AxFJydgKRLt5qFGcN+FDjwfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-jNkDRd_bOB2PH4qi3otX4g-1; Fri, 07 May 2021 23:13:20 -0400
X-MC-Unique: jNkDRd_bOB2PH4qi3otX4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AC098042A6;
        Sat,  8 May 2021 03:13:17 +0000 (UTC)
Received: from localhost (ovpn-13-42.pek2.redhat.com [10.72.13.42])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E85169112;
        Sat,  8 May 2021 03:13:12 +0000 (UTC)
Date:   Sat, 8 May 2021 11:13:09 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Colin King <colin.king@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>, dyoung@redhat.com,
        Frederic Weisbecker <frederic@kernel.org>,
        gpiccoli@canonical.com, john.p.donnelly@oracle.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Linux-MM <linux-mm@kvack.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Ingo Molnar <mingo@kernel.org>, mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Rapoport <rppt@kernel.org>,
        saeed.mirzamohammadi@oracle.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>, yifeifz2@illinois.edu,
        Hari Bathini <hbathini@linux.ibm.com>, piliu@redhat.com
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <20210508031309.GD2834@localhost.localdomain>
References: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
 <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <CAHk-=wigjok_oSyrwiJMxQgTGYg9QtbG5xomMm9qQeO68MwsRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wigjok_oSyrwiJMxQgTGYg9QtbG5xomMm9qQeO68MwsRw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Linus,

On 05/07/21 at 12:25am, Linus Torvalds wrote:
> On Thu, May 6, 2021 at 6:04 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> > Subject: kernel/crash_core: add crashkernel=auto for vmcore creation
> >
> > This adds crashkernel=auto feature to configure reserved memory for vmcore
> > creation.  CONFIG_CRASH_AUTO_STR is defined to be set for different kernel
> > distributions and different archs based on their needs.


> 
> Ugh. I didn't realize how nasty this was until after I'd applied this patch.
> 
> I'm going to drop this patch, because the Kconfig thing for it is an
> unmitigated mess. I was confused by the question, and then the help
> message was actively misleading.
> 
> This is wrong for so many reasons:
> 
>  - this is a classic case of "you shouldn't ask a user this".
> 
>    The question makes no sense to any normal person, it certainly
> didn't to me. Don't ask questions that don't have sane answers.
> 
>  - the config help text is actively misleading, and claims that the
> option is about how much memory is reserved for a crash kernel
> 
>    Not so. It's the default string for when somebody uses "crashkernel=auto"

Sorry for the confusion, we should have been more careful to reivew and
add the commit log and kernel config description.
> 
>  - this shouldn't be a config option at all, it's clearly a distro
> setting, and should be on the kernel command line with the other
> distro settings.

Don't know kernel config is disliked sometime, will remember it in the
future and more cautiously to add. 

Crashkernel=auto exists in our distros for many years, and as David
mentioned in other thread, we have been trying to adding rashkernel=auto
support into upstream. We pursue crashkernel=auto being added to upstream
because:

1) Empirical value is given to user by default;

It was required by customer originally, now has been an important part
of kdump feature and supported in several main ARCHes. With crashkernel=auto,
people w/o much knowledge of kdump details can use kdump to debug. Distros
can provide the suggested values with crashkernel=auto which are got by
investigation, analysis and tested widely on test environment. 

2) Cover corner case/special case;

In some cases, kernel may need extra memory to handle, kdump kernel is
not exceptional. E.g when sme/sev enabled, SWIOTLB will be enabled
necessarily, even in kdump kernel. (Below sme/sev related commits for
reference). Then extra 64M need be reserved for crashkernel. User
doesn't need to know this, we already have done it for them.

commit c7753208a94c ("x86, swiotlb: Add memory encryption support")
commit aba2d9a6385a ("iommu/amd: Do not disable SWIOTLB if SME is active")
commit d7b417fa08d1 ("x86/mm: Add DMA support for SEV memory encryption")

We are eager to push crashkernel=auto to upstream becasue of our
UPSTREAM FIRST rule. Since it has been in RHEL for many years, each time
a new RHEL main release anchor a upstream kernel release and is prepared,
these crashkernel=auto RHEL-only patches need be reviewed inside Redhat,
then we will be questioned and challenged why they are not in upstream.

As for how to implement crashkernel=auto, we have tried several ways.

1) Add into kernel command line

The suggested value need be stored in user space if added into kernel
command line, then added into kernel. This makes the suggested value
separated from kernel itself. It's not what we expect to see. Because
the suggested crashkernel value is strongly related to distros release.
We could adjust the value between sub-releases of kernel because of
of kernel change. Adding them into kernel command line make us lose the
track of them in kernel.

2) Add a weak generic function and several arch dependent functions
3) Hardcode values in __parse_crashkernel()

Method 2) is taken in our RHEL7, 3) is used in RHEL8, RHEL-only patches
add them. If we try to push them into upstram, any later value
adjustment need a upstream patch posting. Otherwise, RHEL-only patch
need be introduced again, Redhat internal reviewer will challenge us
again. (Put the value hard coding pieces at bottom for reference).

4) Add kernel config to add default value

It's done in this patch. With the kernel config CRASH_AUTO_STR, Distros can
add default value, and adjust it anytime in the future w/o bothering
upstream. If crashkernel=auto is specified, only below 3 LOC added, to
go to parse the CONFIG_CRASH_AUTO_STR directly.

@@ -250,6 +251,12 @@ static int __init __parse_crashkernel(ch
        if (suffix)
                return parse_crashkernel_suffix(ck_cmdline, crash_size,
                                suffix);
+#ifdef CONFIG_CRASH_AUTO_STR
+       if (strncmp(ck_cmdline, "auto", 4) == 0) {
+               ck_cmdline = CONFIG_CRASH_AUTO_STR;
+               pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
+       }
+#endif


Before this, we don't know Saeed Mirzamohammadi, the patch author. He
could experience the same torture. We were wild with joy when noticing
his patch. We were planning to launch new round of post to add
crashkernel=auto, kernel config is our final option too. We could be too
happy to forget polishing the commit log.

Not sure if I make myself clear. Basically, we expect crashkernel=auto
to be added in upstream kernel. About how to implement it in kernel, we would
like to hear upstream people's suggestion.

Thanks
Baoquan


Hard code crashkernel=auto values in __parse_crashkernel()
===========================================================
static int __init __parse_crashkernel(char *cmdline,
                             unsigned long long system_ram,
                             unsigned long long *crash_size,
                             unsigned long long *crash_base,
                             const char *name,
                             const char *suffix)
{
......
        if (strncmp(ck_cmdline, "auto", 4) == 0) {
#if defined(CONFIG_X86_64) || defined(CONFIG_S390)
                ck_cmdline = "1G-4G:160M,4G-64G:192M,64G-1T:256M,1T-:512M";
#elif defined(CONFIG_ARM64)
                ck_cmdline = "2G-:448M";
#elif defined(CONFIG_PPC64)
                char *fadump_cmdline;

                fadump_cmdline = get_last_crashkernel(cmdline, "fadump=", NULL);
                fadump_cmdline = fadump_cmdline ?
                                fadump_cmdline + strlen("fadump=") : NULL;
                if (!fadump_cmdline || (strncmp(fadump_cmdline, "off", 3) == 0))
                        ck_cmdline = "2G-4G:384M,4G-16G:512M,16G-64G:1G,64G-128G:2G,128G-:4G";
                else
                        ck_cmdline = "4G-16G:768M,16G-64G:1G,64G-128G:2G,128G-1T:4G,1T-2T:6G,2T-4T:12G,4T-8T:20G,8T-16T:36G,16T-32T:64G,32T-64T:128G,64T-:180G";
#endif
                pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
        }

......
}
==================================================================




