From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2013-06-27-16-36 uploaded (wait event common)
Date: Thu, 27 Jun 2013 22:51:39 -0700
Message-ID: <20130627225139.798e7b00.akpm@linux-foundation.org>
References: <20130627233733.BAEB131C3BE@corp2gmr1-1.hot.corp.google.com>
	<51CD1F81.4040202@infradead.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3F1FwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 01:52:00 -0400
In-Reply-To: <51CD1F81.4040202@infradead.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>

On Thu, 27 Jun 2013 22:30:41 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> On 06/27/13 16:37, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2013-06-27-16-36 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> 
> My builds are littered with hundreds of warnings like this one:
> 
> drivers/tty/tty_ioctl.c:220:6: warning: the omitted middle operand in ?: will always be 'true', suggest explicit middle operand [-Wparentheses]
> 
> I guess due to this line from wait_event_common():
> 
> +		__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;
> 

Ah, sorry, I missed that.  Had I noticed it, I would have spat it back
on taste grounds alone, it being unfit for human consumption.

Something like this?

--- a/include/linux/wait.h~wait-introduce-wait_event_commonwq-condition-state-timeout-fix
+++ a/include/linux/wait.h
@@ -196,7 +196,11 @@ wait_queue_head_t *bit_waitqueue(void *,
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, state);			\
 		if (condition) {					\
-			__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
+			__ret = __wait_no_timeout(tout);		\
+			if (!__ret)					\
+				__ret = __tout;				\
+				if (!__ret)				\
+					__ret = 1;			\
 			break;						\
 		}							\
 									\


