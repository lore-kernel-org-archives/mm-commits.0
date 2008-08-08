From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch
 added to -mm tree
Date: Fri, 8 Aug 2008 14:28:47 -0700
Message-ID: <20080808142847.9e4f33b2.akpm@linux-foundation.org>
References: <200808082051.m78KpZGC027833@imap1.linux-foundation.org>
	<86802c440808081413u2249fff1g1940ff472cdf10e7@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755627AbYHHV2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:28:52 -0400
In-Reply-To: <86802c440808081413u2249fff1g1940ff472cdf10e7@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, rene.herman@keyaccess.nl, rene.herman@gmail.com

On Fri, 8 Aug 2008 14:13:29 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> > commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly nopped
> > debugging printks in arch/x86/kernel/mppparse.c into regular ones.  The
> > one at the top of smp_scan_config() in particular also prints on
> > !CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines without anything
> > resembling MP tables which makes their lowly UP owners wonder...
> >
> > Given that it was up to this point also not considered valuable user-level
> > information, let's just kill that one.
> >
>
> why?  that just three lines debug debug info.

For the reasons described in the changelog text.  They look quite valid
to me.
