From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + seq_read-info-message-about-buggy-next-functions.patch added
 to -mm tree
Date: Mon, 2 Mar 2020 12:42:19 -0800
Message-ID: <20200302124219.eaf3d18422b76ff2196d9ce8@linux-foundation.org>
References: <20200226035621.4NlNn738T%akpm@linux-foundation.org>
        <1583173259.7365.142.camel@lca.pw>
        <1583177508.7365.144.camel@lca.pw>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgCBUmV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 15:42:21 -0500
In-Reply-To: <1583177508.7365.144.camel@lca.pw>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: linux-kernel@vger.kernel.org, dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, vvs@virtuozzo.com

On Mon, 02 Mar 2020 14:31:48 -0500 Qian Cai <cai@lca.pw> wrote:

> On Mon, 2020-03-02 at 13:20 -0500, Qian Cai wrote:
> > This patch spams the console like crazy while reading sysfs,
> > 
> > # dmesg | grep 'buggy seq_file' | wc -l
> > 4204
> > 
> > [ 9505.321981] LTP: starting read_all_proc (read_all -d /proc -q -r 10)
> > [ 9508.222934] buggy seq_file .next function xt_match_seq_next [x_tables] did
> > not updated position index
> > [ 9508.223319] buggy seq_file .next function xt_match_seq_next [x_tables] did
> > not updated position index
> > [ 9508.223654] buggy seq_file .next function xt_match_seq_next [x_tables] did
> > not updated position index
> > [ 9508.223994] buggy seq_file .next function xt_match_seq_next [x_tables] did
> > not updated position index
> > [ 9508.224337] buggy seq_file .next function xt_match_seq_next [x_tables] did
> > not updated position index
> > ...
> > 
> > 
> > > --- a/fs/seq_file.c~seq_read-info-message-about-buggy-next-functions
> > > +++ a/fs/seq_file.c
> > > @@ -256,9 +256,12 @@ Fill:
> > >  		loff_t pos = m->index;
> > >  
> > >  		p = m->op->next(m, p, &m->index);
> > > -		if (pos == m->index)
> > > -			/* Buggy ->next function */
> > > +		if (pos == m->index) {
> > > +			pr_info("buggy seq_file .next function %ps "
> > > +				"did not updated position index\n",
> > > +				m->op->next);
> 
> This?
> 
> s/pr_info/pr_info_ratelimited/
> 

Fair enough - I made that change.
