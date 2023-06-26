Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B94EB64D7
	for <mm-commits@archiver.kernel.org>; Mon, 26 Jun 2023 06:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjFZGwW convert rfc822-to-8bit (ORCPT
        <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjFZGwT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2023 02:52:19 -0400
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6746FAC
        for <mm-commits@vger.kernel.org>; Sun, 25 Jun 2023 23:52:14 -0700 (PDT)
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay01.hostedemail.com (Postfix) with ESMTP id 570231C82EF;
        Mon, 26 Jun 2023 06:52:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id 7FE2220024;
        Mon, 26 Jun 2023 06:52:09 +0000 (UTC)
Message-ID: <f460e849dfdf5d4d18e3714f18e0aabc1d27d318.camel@perches.com>
Subject: Re: + cred-convert-printks-to-pr_level.patch added to
 mm-nonmm-unstable branch
From:   Joe Perches <joe@perches.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, zwp10758@gmail.com,
        senozhatsky@chromium.org, pc@cjr.nz, mcgrof@kernel.org,
        keescook@chromium.org, tiozhang@didiglobal.com
Date:   Sun, 25 Jun 2023 23:52:08 -0700
In-Reply-To: <2023062647-baton-opacity-7bcc@gregkh>
References: <20230625035813.A23CAC433C8@smtp.kernel.org>
         <419ec62b9e88140ac75bd2dae7c94b13acb6b015.camel@perches.com>
         <2023062647-baton-opacity-7bcc@gregkh>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.48.3 (3.48.3-1.fc38) 
MIME-Version: 1.0
X-Stat-Signature: tc3um95fbtwp5rqa7nmxwpb44geazj1c
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 7FE2220024
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18nBihhx2XxCoYit5SBgrtF5xvi8DklCyI=
X-HE-Tag: 1687762329-535808
X-HE-Meta: U2FsdGVkX18ZAR10B0JbHnuzFWxI1Hmhp3niarrlTffwajKwblcpwfmOGMFm3mKMby+a2OB6B3tGoUbUtoDeXWKgIhTmG7p1V8VKv8fMUqsHYbf3CzBtSdRDKxhsYdU2Dw6sP7YRqF+1MsHGJvulGzVLAYQWVWNvsffQBbCIn2IPQhDma7iA4WEmqLAFl/tfqeKCeTj5Uab6bIuQGXPsnibLYHxbTiSOj/5Zw1CWdfhT3gAiMH+6O8RDTrQVPpGfDjtskg9nHGU0oQJacTknxIR7Wd8ibo3WU99qUBE5+sdXUyaGzWHX1z42hnJjBbzTOTsWDEu57BHiv1YuyJBAUHg/T6ZOK2dxWV9f+/Kg9yiOShOSYwJIQM1js6mR0j+9SXcsTtzK9SRMAlZk5b+exDudy10GUQnaF6eZ3v153P5HTFGPfVLr6+cMDx0eKZ9Hr6lqJPZjfG5izfNtpTF/TafpjZ3DysPDeGiO7mu0LyTjbAhT56lv1j54nBtKMnuJNfb93ZwbDqRnuzlWRkQul3WKpjRosh2/numChYNNXKSAkjN4edKR36h6OfrwzkbITSNoNOlu40VIp7ATDwC1/uJMAtyILdL6EqaHBsg9AhCyVpU6wKvKxbEL3cQt5Y2PAbSg3YfukWcYoAGAcEB2pSJ7HLNDcKDfF7UfvC+1gjIRq0NCQNEd8G2BdnsZVG9fbpjWilMKhw8e8ChhXxnIgQ==
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 2023-06-26 at 08:08 +0200, Greg KH wrote:
> On Sun, Jun 25, 2023 at 02:38:39PM -0700, Joe Perches wrote:
> > On Sat, 2023-06-24 at 20:58 -0700, Andrew Morton wrote:
> > > The patch titled
> > >      Subject: cred: convert printks to pr_<level>
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      cred-convert-printks-to-pr_level.patch
> > > 
> > > This patch will shortly appear at
> > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cred-convert-printks-to-pr_level.patch
> > > 
> > > This patch will later appear in the mm-nonmm-unstable branch at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > > 
> > > Before you just go and hit "reply", please:
> > >    a) Consider who else should be cc'ed
> > >    b) Prefer to cc a suitable mailing list as well
> > >    c) Ideally: find the original patch on the mailing list and do a
> > >       reply-to-all to that, adding suitable additional cc's
> > > 
> > > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > > 
> > > The -mm tree is included into linux-next via the mm-everything
> > > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > > and is updated there every 2-3 working days
> > > 
> > > ------------------------------------------------------
> > > From: tiozhang <tiozhang@didiglobal.com>
> > > Subject: cred: convert printks to pr_<level>
> > > Date: Sun, 25 Jun 2023 11:34:52 +0800
> > > 
> > > Use current logging style.
> > > 
> > > Link: https://lkml.kernel.org/r/20230625033452.GA22858@didi-ThinkCentre-M930t-N000
> > > Signed-off-by: tiozhang <tiozhang@didiglobal.com>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Joe Perches <joe@perches.com>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Luis Chamberlain <mcgrof@kernel.org>
> > > Cc: Paulo Alcantara <pc@cjr.nz>
> > > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > Cc: Weiping Zhang <zwp10758@gmail.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> > > 
> > >  kernel/cred.c |   27 +++++++++++++++------------
> > >  1 file changed, 15 insertions(+), 12 deletions(-)
> > > 
> > > --- a/kernel/cred.c~cred-convert-printks-to-pr_level
> > > +++ a/kernel/cred.c
> > > @@ -4,6 +4,9 @@
> > >   * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
> > >   * Written by David Howells (dhowells@redhat.com)
> > >   */
> > > +
> > > +#define pr_fmt(fmt) "CRED: " fmt
> > 
> > My preference would be to use
> > 
> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > 
> > but it likely doesn't matter too much.
> 
> The patch as-is keeps the messages identical to before, so it should
> probably stay this way.

Generally these message prefixes are lowercase and the
dmesg output is not guaranteed to be stable.

One day it'd be trivially useful to standardize the
output style of pr_<foo> uses and remove the typical
pr_fmt defines and only use a define in exceptional cases

$ git grep -Ph 'define\s+pr_fmt\(' | \
  sed -r 's/\s+/ /g' | \
  sort | uniq -c | sort -rn | head -10
   1280 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
    145 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
     37 #define pr_fmt(fmt) "%s: " fmt, __func__
     22 #define pr_fmt(fmt) "ACPI: " fmt
     21 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
     19 #define pr_fmt(fmt) fmt
     17 #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
     14 #define pr_fmt(fmt) "[drm:%s:%d] " fmt, __func__, __LINE__
     13 #define pr_fmt(fmt) "xen:" KBUILD_MODNAME ": " fmt
     12 #define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__

