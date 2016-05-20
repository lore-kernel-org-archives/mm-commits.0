From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2016-05-19-19-59 uploaded
Date: Thu, 19 May 2016 22:39:26 -0700
Message-ID: <20160519223926.c2a6c169287c048ee78ec151@linux-foundation.org>
References: <573e7da6.pLi6U/36fnX6Drn0%akpm@linux-foundation.org>
	<20160520051417.GA6808@bbox>
	<20160520053628.GB6808@bbox>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbcETFj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 01:39:29 -0400
In-Reply-To: <20160520053628.GB6808@bbox>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz, broonie@kernel.org, jack@suse.cz


Someone stuck a load of for-4.8 stuff into -next during the merge
window.  It had better be for 4.8 anyway - it is super-late.

I intend to simply ignore it and merge the for-4.7 material.

On Fri, 20 May 2016 14:36:28 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Ccing Jan,
> 
> dax: Remove complete_unwritten argument
> 
> On Fri, May 20, 2016 at 02:14:17PM +0900, Minchan Kim wrote:
> > On Thu, May 19, 2016 at 07:59:50PM -0700, akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2016-05-19-19-59 has been uploaded to
> > > 
> > >    http://www.ozlabs.org/~akpm/mmotm/
> > > 
> > > mmotm-readme.txt says
> > > 
> > > README for mm-of-the-moment:
> > > 
> > > http://www.ozlabs.org/~akpm/mmotm/
> > > 
> > > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > > more than once a week.
> > > 
> > > You will need quilt to apply these patches to the latest Linus release (4.x
> > > or 4.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > > http://ozlabs.org/~akpm/mmotm/series
> > > 
> > > The file broken-out.tar.gz contains two datestamp files: .DATE and
> > > .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> > > followed by the base kernel version against which this patch series is to
> > > be applied.
> > > 
> > > This tree is partially included in linux-next.  To see which patches are
> > > included in linux-next, consult the `series' file.  Only the patches
> > > within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
> > > linux-next.
> > > 
> > > A git tree which contains the memory management portion of this tree is
> > > maintained at git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
> > > by Michal Hocko.  It contains the patches which are between the
> > > "#NEXT_PATCHES_START mm" and "#NEXT_PATCHES_END" markers, from the series
> > > file, http://www.ozlabs.org/~akpm/mmotm/series.
> > > 
> > > 
> > > A full copy of the full kernel tree with the linux-next and mmotm patches
> > > already applied is available through git within an hour of the mmotm
> > > release.  Individual mmotm releases are tagged.  The master branch always
> > > points to the latest release, so it's constantly rebasing.
> > > 
> > > http://git.cmpxchg.org/cgit.cgi/linux-mmotm.git/
> > > 
> > > To develop on top of mmotm git:
> > > 
> > >   $ git remote add mmotm git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
> > >   $ git remote update mmotm
> > >   $ git checkout -b topic mmotm/master
> > >   <make changes, commit>
> > >   $ git send-email mmotm/master.. [...]
> > > 
> > > To rebase a branch with older patches to a new mmotm release:
> > > 
> > >   $ git remote update mmotm
> > >   $ git rebase --onto mmotm/master <topic base> topic
> > > 
> > > 
> > > 
> > > 
> > > The directory http://www.ozlabs.org/~akpm/mmots/ (mm-of-the-second)
> > > contains daily snapshots of the -mm tree.  It is updated more frequently
> > > than mmotm, and is untested.
> > > 
> > > A git copy of this tree is available at
> > > 
> > > 	http://git.cmpxchg.org/cgit.cgi/linux-mmots.git/
> > > 
> > > and use of this tree is similar to
> > > http://git.cmpxchg.org/cgit.cgi/linux-mmotm.git/, described above.
> > > 
> > 
> > In first build, I got this.
> > 
> > In file included from mm/filemap.c:14:0:
> > include/linux/dax.h:14:3: error: unknown type name ___dax_iodone_t___
> >    dax_iodone_t);
> >    ^
> > include/linux/dax.h:16:3: error: unknown type name ___dax_iodone_t___
> >    dax_iodone_t);
> >    ^
> > include/linux/dax.h:39:5: error: unknown type name ___dax_iodone_t___
> >      dax_iodone_t di)
> >      ^
> > In file included from mm/vmscan.c:49:0:
> > include/linux/dax.h:14:3: error: unknown type name ___dax_iodone_t___
> >    dax_iodone_t);
> >    ^
> > include/linux/dax.h:16:3: error: unknown type name ___dax_iodone_t___
> >    dax_iodone_t);
> >    ^
> > include/linux/dax.h:39:5: error: unknown type name ___dax_iodone_t___
> >      dax_iodone_t di)
> >      ^
> > In file included from mm/truncate.c:12:0:
> > include/linux/dax.h:14:3: error: unknown type name ___dax_iodone_t___
> >    dax_iodone_t);
> >    ^
> > include/linux/dax.h:16:3: error: unknown type name ___dax_iodone_t___
> >    dax_iodone_t);
> >    ^
> > include/linux/dax.h:39:5: error: unknown type name ___dax_iodone_t___
> >      dax_iodone_t di)
> >      ^
> > make[1]: *** [mm/truncate.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make[1]: *** [mm/filemap.o] Error 1
> > make[1]: *** [mm/vmscan.o] Error 1
> > make: *** [mm/] Error 2
> > 
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
