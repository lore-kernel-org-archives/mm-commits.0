From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2020-04-17-20-35 uploaded (squashfs)
Date: Sat, 18 Apr 2020 12:47:28 -0700
Message-ID: <20200418124728.51632dbebc8b5dbc864cc34f__15340.2943675005$1587239260$gmane$org@linux-foundation.org>
References: <20200418033629.oozqt8YrL%akpm@linux-foundation.org>
        <319997c2-5fc8-f889-2ea3-d913308a7c1f@infradead.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgDRTrb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Apr 2020 15:47:31 -0400
In-Reply-To: <319997c2-5fc8-f889-2ea3-d913308a7c1f@infradead.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: broonie@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, Phillip Lougher <phillip@squashfs.org.uk>, squashfs-devel@lists.sourceforge.net, Philippe Liard <pliard@google.com>

On Sat, 18 Apr 2020 08:56:31 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> On 4/17/20 8:36 PM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2020-04-17-20-35 has been uploaded to
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
> > The file broken-out.tar.gz contains two datestamp files: .DATE and
> > .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> > followed by the base kernel version against which this patch series is to
> > be applied.
> 
> on x86_64:
> 
>   CC      fs/squashfs/decompressor_multi_percpu.o
> ../fs/squashfs/decompressor_multi_percpu.c:75:5: error: conflicting types for ‘squashfs_decompress’
>  int squashfs_decompress(struct squashfs_sb_info *msblk, struct buffer_head **bh,
>      ^~~~~~~~~~~~~~~~~~~

Thanks.  Seems that file was missed.

Also, this code jumps through horrifying hoops in order to initialize
locals at their definition site.  But the code looks so much better if
we Just Don't Do That!



From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-migrate-from-ll_rw_block-usage-to-bio-fix

fix build error reported by Randy

Link: http://lkml.kernel.org/r/319997c2-5fc8-f889-2ea3-d913308a7c1f@infradead.org
Cc: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Rosenberg <drosen@google.com>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Philippe Liard <pliard@google.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/decompressor_multi_percpu.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/squashfs/decompressor_multi_percpu.c~squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
+++ a/fs/squashfs/decompressor_multi_percpu.c
@@ -72,14 +72,17 @@ void squashfs_decompressor_destroy(struc
 	}
 }
 
-int squashfs_decompress(struct squashfs_sb_info *msblk, struct buffer_head **bh,
-	int b, int offset, int length, struct squashfs_page_actor *output)
+int squashfs_decompress(struct squashfs_sb_info *msblk, struct bio *bio,
+	int offset, int length, struct squashfs_page_actor *output)
 {
-	struct squashfs_stream __percpu *percpu =
-			(struct squashfs_stream __percpu *) msblk->stream;
-	struct squashfs_stream *stream = get_cpu_ptr(percpu);
-	int res = msblk->decompressor->decompress(msblk, stream->stream, bh, b,
-		offset, length, output);
+	struct squashfs_stream __percpu *percpu;
+	struct squashfs_stream *stream;
+	int res;
+
+	percpu = (struct squashfs_stream __percpu *)msblk->stream;
+	stream = get_cpu_ptr(percpu);
+	res = msblk->decompressor->decompress(msblk, stream->stream, bio,
+					      offset, length, output);
 	put_cpu_ptr(stream);
 
 	if (res < 0)
_
