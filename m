Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8858FC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 14:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E6764EC3
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 14:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBYOcN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 09:32:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhBYOcM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 09:32:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4105964EC3;
        Thu, 25 Feb 2021 14:31:30 +0000 (UTC)
Date:   Thu, 25 Feb 2021 09:31:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jacob Wen <jian.w.wen@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, cl@linux.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
Message-ID: <20210225093128.4cd86439@gandalf.local.home>
In-Reply-To: <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
        <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
        <20210224203708.4489755a@oasis.local.home>
        <20210224210740.73273c7a@oasis.local.home>
        <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 25 Feb 2021 15:07:50 +0800
Jacob Wen <jian.w.wen@oracle.com> wrote:

> > I wonder if we can add something to checkpatch that can check if
> > TP_printk() has a call to "%s" where it references a __entry->xxx and
> > not a __get_str(), and will warn about it.  
> That's helpful for me who don't know "%s" of TP_printk is special.

Here's nothing special about %s in TP_printk. It uses the same code as
printk() and what other string formatters use.

What is special is that the print is on data that is stored from a previous
time.

TP_fast_assign() / TP_printk() is basically this:

struct entry {
	char *name;
} entry;


TP_fast_assign() {
	entry.name = slab->name;
}

TP_printk() {
	printk("%s", entry.name);
}


Where TP_printk() can be called some time in the future when a user asks
for it. If the slab->name is freed, then the entry.name will be pointing to
stale data, and you don't want to call printk() on that!

Thus, the "%s" in TP_printk() is nothing special, it's the fact that the
data it reads is called much later in time from when that data was
recorded. Which means, you can not rely on any dereferencing of pointers.

The __string() __assign_str() and __get_str() macros are helpers to easily
store strings in the ring buffer, as that is a common practice in the
trace events.

-- Steve


> >
> > There a a few cases where its OK. Like RCU uses a TPS() macro around
> > strings it passes into the tracepoint, which is used for strings that
> > never are freed, and maps the string pointer to the string for user
> > space. But RCU is the only user of that I believe.
> >
