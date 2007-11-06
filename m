From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - memory-cgroup-enhancements-add-pre_destroy-handler.patch
 removed from -mm tree
Date: Mon, 5 Nov 2007 23:50:15 -0800
Message-ID: <20071105235015.eb968ad7.akpm@linux-foundation.org>
References: <200711060721.lA67LTeo012008@imap1.linux-foundation.org>
	<20071106164447.98fa9032.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbXKFHvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 02:51:24 -0500
In-Reply-To: <20071106164447.98fa9032.kamezawa.hiroyu@jp.fujitsu.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org

On Tue, 6 Nov 2007 16:44:47 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 05 Nov 2007 23:14:40 -0800
> akpm@linux-foundation.org wrote:
> 
> > 
> > The patch titled
> >      memory cgroup enhancements: add pre_destroy handler
> > has been removed from the -mm tree.  Its filename was
> >      memory-cgroup-enhancements-add-pre_destroy-handler.patch
> > 
> > This patch was dropped because I can't get it to compile - new version after next -mm, please
> > 
> 
> Hmm, ok. I'll reschedule this and next one.

Thanks.

> But is there objections to pre_destroy handler ?

Dunno, I haven't been paying much attention.  Has anyone else?  It's a bit
suspicious that nobody noticed that this would cause obvious build
errors.

More reviewing effort please, guys.

> If we should deal with reference count of following in another way,
> ==
>    page->page_cgroup->memory_cgroup, memory_cgroup contains css.
>    page_cgroup has ref to css.
> ==
> I'll consider something. (for example, add refcnt to memory_cgroup itself.)
> 
> Changing above may allow us to guarantee that if no task, css's refcnt is 0.
