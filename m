From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2017-11-10-15-56 uploaded (lib/test_find_bit.c)
Date: Mon, 13 Nov 2017 16:17:41 -0800
Message-ID: <20171113161741.5feaa74b30527f05b1684d10__18024.0990747281$1510618680$gmane$org@linux-foundation.org>
References: <5a063cc8.w9SFxvjWsZNJM4HP%akpm@linux-foundation.org>
        <2ce9cf55-2b54-b6cd-fa4d-3cd0a354b5f1@infradead.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdKNARn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2017 19:17:43 -0500
In-Reply-To: <2ce9cf55-2b54-b6cd-fa4d-3cd0a354b5f1@infradead.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz, broonie@kernel.org, Yury Norov <ynorov@caviumnetworks.com>

On Fri, 10 Nov 2017 18:00:57 -0800 Randy Dunlap <rdunlap@infradead.org> wrote:

> On 11/10/2017 03:56 PM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2017-11-10-15-56 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> 
> on i386:
> 
> ../lib/test_find_bit.c:54:2: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'cycles_t' [-Wformat=]
> ../lib/test_find_bit.c:68:2: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'cycles_t' [-Wformat=]
> ../lib/test_find_bit.c:82:2: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'cycles_t' [-Wformat=]
> ../lib/test_find_bit.c:102:2: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'cycles_t' [-Wformat=]

typecasts, I guess?  We don't seem to have a %p thingy for cycles_t?

--- a/lib/test_find_bit.c~lib-test-module-for-find__bit-functions-fix
+++ a/lib/test_find_bit.c
@@ -51,7 +51,8 @@ static int __init test_find_first_bit(vo
 		__clear_bit(i, bitmap);
 	}
 	cycles = get_cycles() - cycles;
-	pr_err("find_first_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_first_bit:\t\t%ld cycles,\t%ld iterations\n",
+		(long)cycles, cnt);
 
 	return 0;
 }
@@ -65,7 +66,8 @@ static int __init test_find_next_bit(con
 	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
 		i = find_next_bit(bitmap, BITMAP_LEN, i) + 1;
 	cycles = get_cycles() - cycles;
-	pr_err("find_next_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_next_bit:\t\t%ld cycles,\t%ld iterations\n",
+		(long)cycles, cnt);
 
 	return 0;
 }
@@ -80,7 +82,7 @@ static int __init test_find_next_zero_bi
 		i = find_next_zero_bit(bitmap, len, i) + 1;
 	cycles = get_cycles() - cycles;
 	pr_err("find_next_zero_bit:\t%ld cycles,\t%ld iterations\n",
-								cycles, cnt);
+		(long)cycles, cnt);
 
 	return 0;
 }
@@ -99,7 +101,8 @@ static int __init test_find_last_bit(con
 		len = l;
 	} while (len);
 	cycles = get_cycles() - cycles;
-	pr_err("find_last_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_last_bit:\t\t%ld cycles,\t%ld iterations\n",
+		(long)cycles, cnt);
 
 	return 0;
 }
_

