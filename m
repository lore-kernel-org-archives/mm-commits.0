From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2010-10-13-17-13 uploaded
Date: Thu, 14 Oct 2010 12:16:27 -0700
Message-ID: <20101014121627.2405e99a.akpm@linux-foundation.org>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	<AANLkTin1RjhDZp6w-jumRnZ1-Hx3zio7SrZtZqummok2@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009Ab0JNTRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 15:17:04 -0400
In-Reply-To: <AANLkTin1RjhDZp6w-jumRnZ1-Hx3zio7SrZtZqummok2@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>

On Thu, 14 Oct 2010 12:26:45 +0200
Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:

> 2010/10/14  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> 
> linux-next.patch breaks things
> 
>   GEN     /home/test/linux-2.6-obj/Makefile
>   HOSTCC  scripts/kconfig/zconf.tab.o
> In file included from scripts/kconfig/zconf.tab.c:2462:0:
> scripts/kconfig/lex.zconf.c:2425:7: error: conflicting types for 'zconf_curname'
> /home/test/linux-2.6-mm/scripts/kconfig/lkc.h:79:13: note: previous
> declaration of 'zconf_curname' was here
> scripts/kconfig/lex.zconf.c: In function 'zconf_curname':
> scripts/kconfig/lex.zconf.c:2427:2: warning: return discards
> qualifiers from pointer target type
> make[3]: *** [scripts/kconfig/zconf.tab.o] Error 1
> make[2]: *** [silentoldconfig] Error 2
> make[1]: *** No rule to make target `include/config/auto.conf', needed
> by `include/config/kernel.release'.  Stop.
> make: *** [sub-make] Error 2
> 

Something went wrong with the zconf_curname() constification.

lex scripts never seem to get along well with the build dependency
systems - did you try a `make mrproper' and a rebuild?

