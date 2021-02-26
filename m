Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F546C433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 14:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 053CA64F1A
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 14:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBZOEv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 09:04:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhBZOEk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 09:04:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E421564EED;
        Fri, 26 Feb 2021 14:03:56 +0000 (UTC)
Date:   Fri, 26 Feb 2021 09:03:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, pmladek@suse.com,
        sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject: Re: [patch 067/118] tracing: add error_report_end trace point
Message-ID: <20210226090355.227d689e@gandalf.local.home>
In-Reply-To: <20210226011944.aSSBVuJAj%akpm@linux-foundation.org>
References: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
        <20210226011944.aSSBVuJAj%akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 25 Feb 2021 17:19:44 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> +#define show_error_detector_list(val) \
> +	__print_symbolic(val, error_detector_list)
> +
> +DECLARE_EVENT_CLASS(error_report_template,
> +		    TP_PROTO(enum error_detector error_detector, unsigned long id),
> +		    TP_ARGS(error_detector, id),
> +		    TP_STRUCT__entry(__field(enum error_detector, error_detector)
> +					     __field(unsigned long, id)),
> +		    TP_fast_assign(__entry->error_detector = error_detector;
> +				   __entry->id = id;),
> +		    TP_printk("[%s] %lx",
> +			      show_error_detector_list(__entry->error_detector),
> +			      __entry->id));
> +
> +/**

This doesn't need to change right now, but FYI, do not follow checkpatch
formatting for TRACE_EVENT() and friend macros. The above is really hard to
read for a trace event. It should look like this:

DECLARE_EVENT_CLASS(error_report_template,

	TP_PROTO(enum error_detector error_detector, unsigned long id),

	TP_ARGS(error_detector, id),

	TP_STRUCT__entry(
		__field(enum error_detector, error_detector)
		__field(unsigned long, id)
	),

	TP_fast_assign(
		__entry->error_detector = error_detector;
		__entry->id = id;
	),

	TP_printk("[%s] %lx",
		  show_error_detector_list(__entry->error_detector),
		  __entry->id)
);


As it's not really a macro, but code, and see, it's MUCH easier to read!
Because we see the prototype, the structure definition, the code that
assigns that structure, and how to print it. Following what checkpatch
says, is equivalent to writing code like this:

void trace_error_report_template
		    (enum error_detector error_detector, unsigned long id) {
		    struct entry {enum error_detector error_detector;
		                  unsigned long id;};
		    __entry->error_detector = error_detector;
				   __entry->id = id;
		    printk("[%s] %lx",
			   show_error_detector_list(__entry->error_detector),
			   __entry->id)); }


It doesn't need to be fixed now. I'll try to remember to fix it after it
lands in my tree.

-- Steve
