From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mmotm:master 277/310]
 kernel/trace/trace_functions_graph.c:173:27: error: 'struct
 ftrace_ret_stack' has no member named 'subtime'; did you mean 'calltime'?
Date: Tue, 4 Oct 2016 16:45:31 -0700
Message-ID: <20161004164531.427e35253f230f2a510a1c13__13067.3955231488$1475624741$gmane$org@linux-foundation.org>
References: <201610050750.gvhXrSoc%fengguang.wu@intel.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754196AbcJDXpd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2016 19:45:33 -0400
In-Reply-To: <201610050750.gvhXrSoc%fengguang.wu@intel.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Linux Memory Management List <linux-mm@kvack.org>, mmotm auto import <mm-commits@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>

On Wed, 5 Oct 2016 07:35:53 +0800 kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   git://git.cmpxchg.org/linux-mmotm.git master
> head:   b9215f97283c8239d33a0ea59d0a7ce7060a7255
> commit: 05fd6fa64d9f004ab1321df8d5640e301ab48bc5 [277/310] linux-next-git-rejects
> config: x86_64-allyesdebian (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         git checkout 05fd6fa64d9f004ab1321df8d5640e301ab48bc5
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    kernel/trace/trace_functions_graph.c: In function 'ftrace_push_return_trace':
> >> kernel/trace/trace_functions_graph.c:173:27: error: 'struct ftrace_ret_stack' has no member named 'subtime'; did you mean 'calltime'?
>      current->ret_stack[index].subtime = 0;
>                               ^
> 
> vim +173 kernel/trace/trace_functions_graph.c
> 
> 29ad23b0 Namhyung Kim      2013-10-14  167  	if (ftrace_graph_notrace_addr(func))
> 29ad23b0 Namhyung Kim      2013-10-14  168  		current->curr_ret_stack -= FTRACE_NOTRACE_DEPTH;
> 712406a6 Steven Rostedt    2009-02-09  169  	barrier();
> 712406a6 Steven Rostedt    2009-02-09  170  	current->ret_stack[index].ret = ret;
> 712406a6 Steven Rostedt    2009-02-09  171  	current->ret_stack[index].func = func;
> 5d1a03dc Steven Rostedt    2009-03-23  172  	current->ret_stack[index].calltime = calltime;
> a2a16d6a Steven Rostedt    2009-03-24 @173  	current->ret_stack[index].subtime = 0;
> 88e052f9 mmotm auto import 2016-10-04  174  #ifdef HAVE_FUNCTION_GRAPH_FP_TEST
> 71e308a2 Steven Rostedt    2009-06-18  175  	current->ret_stack[index].fp = frame_pointer;
> 88e052f9 mmotm auto import 2016-10-04  176  #endif
> 

Gumble.  That's me fixing git rejects and getting it wrong.  Rejects
which, I believe, are caused by people sending stuff to Linus which is
different from what they have (or had) in -next.
