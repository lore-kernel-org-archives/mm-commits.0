From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2020-06-25-20-36 uploaded (mm/memory-failure.c)
Date: Fri, 26 Jun 2020 20:41:48 -0700
Message-ID: <20200626204148.6c8c3c359e8baa310ecb744f@linux-foundation.org>
References: <20200626033744.URfGO%akpm@linux-foundation.org>
        <700cf5c7-6e8c-4c09-5ab6-5f946689b012@infradead.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0Dlv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:41:51 -0400
In-Reply-To: <700cf5c7-6e8c-4c09-5ab6-5f946689b012@infradead.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: broonie@kernel.org, mhocko@suse.cz, sfr@canb.auug.org.au, linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On Fri, 26 Jun 2020 15:09:08 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> On 6/25/20 8:37 PM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2020-06-25-20-36 has been uploaded to
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
> > 
> > You will need quilt to apply these patches to the latest Linus release (5.x
> > or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > http://ozlabs.org/~akpm/mmotm/series
> > 
> 
> when CONFIG_MIGRATION is not set/enabled:
> 
> ../mm/memory-failure.c: In function ‘new_page’:
> ../mm/memory-failure.c:1692:9: error: implicit declaration of function ‘alloc_migration_target’; did you mean ‘alloc_migrate_target’? [-Werror=implicit-function-declaration]
>   return alloc_migration_target(p, (unsigned long)&mtc);
>          ^~~~~~~~~~~~~~~~~~~~~~
>          alloc_migrate_target
> ../mm/memory-failure.c:1692:9: warning: return makes pointer from integer without a cast [-Wint-conversion]
>   return alloc_migration_target(p, (unsigned long)&mtc);
>          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks.

Appears to be due to Joonsoo Kim's "mm/migrate: make a standard
migration target allocation function".
